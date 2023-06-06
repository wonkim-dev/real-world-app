import { Injectable, Logger } from '@nestjs/common';
import { DataSource, In, QueryRunner } from 'typeorm';
import slugify from 'slugify';
import { v4 as uuidv4 } from 'uuid';
import { DecodedAccessToken } from '../../models/model';
import { ArticleData, CreateArticleInput } from './article.model';
import { Article, ArticleTagMapping, Tag } from '../../entities';
import { ProfileService } from '../account/profile/profile.service';

@Injectable()
export class ArticleService {
  private readonly logger = new Logger(ArticleService.name);

  constructor(private dataSource: DataSource, private profileService: ProfileService) {}

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
      const articleData = await this.buildArticleDataResponse(queryRunner, article.articleId, decodedAccessToken);
      await queryRunner.commitTransaction();
      return articleData;
    } catch (error) {
      this.logger.error(error);
      await queryRunner.rollbackTransaction();
    } finally {
      await queryRunner.release();
    }
  }

  private async buildArticleDataResponse(
    queryRunner: QueryRunner,
    articleId: number,
    decodedAccessToken: DecodedAccessToken
  ): Promise<ArticleData> {
    const articleWithRelation = await this.getArticleWithRelations(queryRunner, articleId);
    const articleAuthor = await this.profileService.getProfile(decodedAccessToken.preferred_username, decodedAccessToken);
    const articleData = this.getArticleData(articleWithRelation);
    articleData.author = articleAuthor;
    return articleData;
  }

  private getArticleData(articleWithRelation: Article): ArticleData {
    const favoritesCount = articleWithRelation.articleUserMappingsByFkArticleId.length;
    const tagListResponse = articleWithRelation.articleTagMappingsByFkArticleId.map(
      (articleTagMapping) => articleTagMapping.tagByFkTagId.name
    );
    const articleData = new ArticleData(articleWithRelation);
    articleData.favoritesCount = favoritesCount;
    articleData.tagList = tagListResponse;
    return articleData;
  }

  private async getArticleWithRelations(queryRunner: QueryRunner, articleId: number): Promise<Article> {
    return await queryRunner.manager.findOne(Article, {
      where: { articleId },
      relations: {
        userByFkUserId: true,
        articleTagMappingsByFkArticleId: { tagByFkTagId: true },
        articleUserMappingsByFkArticleId: true,
      },
    });
  }

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

  private async insertArticleTagMappings(queryRunner: QueryRunner, article: Article, articleTags: Tag[]) {
    const articleTagMappingPayload = this.getArticleTagMappingsPayload(article, articleTags);
    await queryRunner.manager.save(ArticleTagMapping, articleTagMappingPayload);
  }

  private getArticleTagMappingsPayload(article: Article, articleTags: Tag[]) {
    return articleTags.map((tag) => ({ fkArticleId: article.articleId, fkTagId: tag.tagId }));
  }

  private generateUniqueSlug(title: string): string {
    const baseSlug = slugify(title, { lower: true });
    const uniqueIdentifier = uuidv4().split('-')[0];
    return `${baseSlug}-${uniqueIdentifier}`;
  }
}
