import { Injectable, Logger } from '@nestjs/common';
import { DataSource, In, QueryRunner } from 'typeorm';
import slugify from 'slugify';
import { v4 as uuidv4 } from 'uuid';
import { DecodedAccessToken } from '../../models/model';
import { Article, ArticleTagMapping, Tag, User } from '../../entities';
import { ProfileService } from '../account/profile/profile.service';
import { ArticleData, CreateArticleInput } from './article.model';
import { ArticleMissingQueryStringError, ArticleNotFoundError } from './article.error';

@Injectable()
export class ArticleService {
  private readonly logger = new Logger(ArticleService.name);

  constructor(private dataSource: DataSource, private profileService: ProfileService) {}

  /**
   * @description Create a new article. Article, tag, article tag mapping are inserted as transactional.
   * Missing tags and corresponding mappings are created.
   */
  async createArticle(decodedAccessToken: DecodedAccessToken, createArticleInput: CreateArticleInput): Promise<ArticleData> {
    const { title, description, body, tagList } = createArticleInput;
    const slug = this.generateUniqueSlug(createArticleInput.title);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.startTransaction();
    try {
      const article = await queryRunner.manager.save(Article, { slug, title, description, body, fkUserId: decodedAccessToken.sub });
      if (tagList && tagList.length) {
        const articleTags = await this.insertMissingTags(queryRunner, tagList);
        await this.insertArticleTagMappings(queryRunner, article, articleTags);
      }
      const articleWithRelation = await this.getOneArticleWithRelationsTransaction(queryRunner, article.articleId);
      const articleData = await this.buildArticleDataResponse([articleWithRelation], decodedAccessToken);
      await queryRunner.commitTransaction();
      return articleData[0];
    } catch (error) {
      this.logger.error(error);
      await queryRunner.rollbackTransaction();
    } finally {
      await queryRunner.release();
    }
  }

  /**
   * @description Fetch a article by slug.
   * @throws {ArticleNotFoundError} Article does not exist.
   */
  async getArticle(slug: string): Promise<ArticleData> {
    const article = await this.dataSource.manager.findOneBy(Article, { slug });
    if (!article) {
      throw new ArticleNotFoundError();
    }
    const articleWithRelation = await this.getOneArticleWithRelations(article.articleId);
    const articleData = await this.buildArticleDataResponse([articleWithRelation]);
    return articleData[0];
  }

  async getArticleList(tag: string, author: string, favoritedBy: string, limit: number, offset: number): Promise<ArticleData[]> {
    if (!tag && !author && !favoritedBy) {
      throw new ArticleMissingQueryStringError();
    }
    let tagId: number;
    let authorUserId: string;
    let favoritingUserId: string;
    if (tag) {
      tagId = (await this.dataSource.manager.findOneBy(Tag, { name: tag }))?.tagId;
    }
    if (author) {
      authorUserId = (await this.dataSource.manager.findOneBy(User, { username: author }))?.userId;
    }
    if (favoritedBy) {
      favoritingUserId = (await this.dataSource.manager.findOneBy(User, { username: favoritedBy }))?.userId;
    }
    const articlesWithRelation = await this.getArticlesWithRelationsPagination(offset, limit, tagId, favoritingUserId, authorUserId);
    return await this.buildArticleDataResponse(articlesWithRelation);
  }

  /**
   * @description Create a list of ArticleData that are returned to the client.
   * @param articleWithRelations List of Article entities with relations.
   * @param decodedAccessToken Authenticated user who send the request (Optional).
   */
  private async buildArticleDataResponse(articleWithRelations: Article[], decodedAccessToken?: DecodedAccessToken): Promise<ArticleData[]> {
    const articleDataList: ArticleData[] = [];
    for (const articleWithRelation of articleWithRelations) {
      const articleAuthor = await this.profileService.getProfile(articleWithRelation.userByFkUserId.username, decodedAccessToken);
      const articleData = this.getArticleData(articleWithRelation, decodedAccessToken?.sub);
      articleData.author = articleAuthor;
      articleDataList.push(articleData);
    }
    return articleDataList;
  }

  /**
   * @description Create ArticleData from Article entity by mapping the properties.
   * @param articleWithRelation Article entity with relations
   * @param requestingUserId Id of requesting user (Optional). If this is passed, favorited field in the response is returned.
   */
  private getArticleData(articleWithRelation: Article, requestingUserId?: string): ArticleData {
    const favoritesCount = articleWithRelation.articleUserMappingsByFkArticleId.length;
    let favorited = false;
    if (requestingUserId) {
      favorited = articleWithRelation.articleUserMappingsByFkArticleId.some(
        (articleUserMapping) => (articleUserMapping.favoritedByFkUserId = requestingUserId)
      );
    }
    const tagList = articleWithRelation.articleTagMappingsByFkArticleId.map((articleTagMapping) => articleTagMapping.tagByFkTagId.name);
    const articleData = {
      slug: articleWithRelation.slug,
      title: articleWithRelation.title,
      description: articleWithRelation.description,
      body: articleWithRelation.body,
      favorited,
      favoritesCount,
      tagList,
      createdAt: articleWithRelation.createdAt.toISOString(),
      updatedAt: articleWithRelation.updatedAt.toISOString(),
      author: null,
    };
    return articleData;
  }

  /**
   * @description Fetch one article and its relations by article id. Executed as transaction.
   * @param queryRunner Query runner to run the operations as transaction.
   * @param articleId Article id to fetch.
   */
  private async getOneArticleWithRelationsTransaction(queryRunner: QueryRunner, articleId: number): Promise<Article> {
    return await queryRunner.manager.findOne(Article, {
      where: { articleId },
      relations: {
        userByFkUserId: true,
        articleTagMappingsByFkArticleId: { tagByFkTagId: true },
        articleUserMappingsByFkArticleId: true,
      },
    });
  }

  /**
   * @description Fetch one article and its relations by article id.
   * @param articleId Article id to fetch.
   */
  private async getOneArticleWithRelations(articleId: number): Promise<Article> {
    return await this.dataSource.manager.findOne(Article, {
      where: { articleId },
      relations: {
        userByFkUserId: true,
        articleTagMappingsByFkArticleId: { tagByFkTagId: true },
        articleUserMappingsByFkArticleId: true,
      },
    });
  }

  /**
   * @description Fetch articles and their relations by query strings.
   * @param offset Query string offset for pagination.
   * @param limit Query string limit for pagination.
   * @param fkTagId Query string fkTagId for filtering article by tag.
   * @param favoritedByFkUserId Query string favoritedByFkUserId for filtering article by favorited.
   * @param fkUserId Query string fkUserId for filtering article by author.
   * @returns Articles ordered by createdAt descending.
   */
  private async getArticlesWithRelationsPagination(
    offset: number,
    limit: number,
    fkTagId: number,
    favoritedByFkUserId: string,
    fkUserId: string
  ): Promise<Article[]> {
    const articles = await this.dataSource.manager.find(Article, {
      relations: {
        userByFkUserId: true,
        articleTagMappingsByFkArticleId: { tagByFkTagId: true },
        articleUserMappingsByFkArticleId: true,
      },
      where: {
        articleTagMappingsByFkArticleId: { fkTagId },
        articleUserMappingsByFkArticleId: { favoritedByFkUserId },
        fkUserId,
      },
      order: { createdAt: 'DESC' },
      skip: offset,
      take: limit,
    });
    return articles;
  }

  /**
   * @description Create missing tags from the passed tagList by comparing to db.
   */
  private async insertMissingTags(queryRunner: QueryRunner, tagList: string[]): Promise<Tag[]> {
    const existingTags = await queryRunner.manager.findBy(Tag, { name: In(tagList) });
    const existingTagNames = existingTags.map((tag) => tag.name);
    const missingTagsPayload = this.getMissingTagsPayload(tagList, existingTagNames);
    const newTags = await queryRunner.manager.save(Tag, missingTagsPayload);
    return [...existingTags, ...newTags];
  }

  private getMissingTagsPayload(tagList: string[], existingTagNames: string[]): { name: string }[] {
    return tagList.filter((tag) => !existingTagNames.includes(tag)).map((name) => ({ name }));
  }

  /**
   * @description Create article tag mappings.
   */
  private async insertArticleTagMappings(queryRunner: QueryRunner, article: Article, articleTags: Tag[]): Promise<void> {
    const articleTagMappingPayload = this.getArticleTagMappingsPayload(article, articleTags);
    await queryRunner.manager.save(ArticleTagMapping, articleTagMappingPayload);
  }

  private getArticleTagMappingsPayload(article: Article, articleTags: Tag[]): { fkArticleId: number; fkTagId: number }[] {
    return articleTags.map((tag) => ({ fkArticleId: article.articleId, fkTagId: tag.tagId }));
  }

  private generateUniqueSlug(title: string): string {
    const baseSlug = slugify(title, { lower: true });
    const uniqueIdentifier = uuidv4().split('-')[0];
    return `${baseSlug}-${uniqueIdentifier}`;
  }
}
