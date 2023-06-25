import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { ProfileService } from '../../account/profile/profile.service';
import { DecodedAccessToken } from '../../../models/model';
import { ArticleData } from '../article.model';
import { Article, ArticleUserMapping } from '../../../entities';
import { ArticleNotFoundError } from '../article.error';

@Injectable()
export class ArticleFavoriteService {
  constructor(private dataSource: DataSource, private profileService: ProfileService) {}

  async favoriteArticle(decodedAccessToken: DecodedAccessToken, slug: string): Promise<ArticleData> {
    const article = await this.dataSource.manager.findOne(Article, {
      where: { slug },
      relations: { userByFkUserId: true, articleTagMappingsByFkArticleId: { tagByFkTagId: true }, articleUserMappingsByFkArticleId: true },
    });
    if (!article) {
      throw new ArticleNotFoundError();
    }
    const articleUserMappingInsertPayload = {
      fkArticleId: article.articleId,
      favoritedByFkUserId: decodedAccessToken.sub,
    } as Partial<ArticleUserMapping>;
    await this.dataSource.manager.save(ArticleUserMapping, articleUserMappingInsertPayload);
    const articleAuthor = await this.profileService.getProfile(article.userByFkUserId.username, decodedAccessToken);
    const articleData = this.buildArticleData(article);
    articleData.favorited = true;
    articleData.favoritesCount += 1;
    articleData.author = articleAuthor;
    return articleData;
  }

  async unfavoriteArticle(decodedAccessToken: DecodedAccessToken, slug: string): Promise<ArticleData> {
    const article = await this.dataSource.manager.findOne(Article, {
      where: { slug },
      relations: { userByFkUserId: true, articleTagMappingsByFkArticleId: { tagByFkTagId: true }, articleUserMappingsByFkArticleId: true },
    });
    if (!article) {
      throw new ArticleNotFoundError();
    }
    await this.dataSource.manager.delete(ArticleUserMapping, {
      fkArticleId: article.articleId,
      favoritedByFkUserId: decodedAccessToken.sub,
    });
    const articleAuthor = await this.profileService.getProfile(article.userByFkUserId.username, decodedAccessToken);
    const articleData = this.buildArticleData(article);
    articleData.favorited = false;
    articleData.favoritesCount -= 1;
    articleData.author = articleAuthor;
    return articleData;
  }

  private buildArticleData(article: Article): ArticleData {
    const articleData = {
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      favorited: null,
      favoritesCount: article.articleUserMappingsByFkArticleId.length,
      tagList: article.articleTagMappingsByFkArticleId.map((articleTagMapping) => articleTagMapping.tagByFkTagId.name),
      createdAt: article.createdAt.toISOString(),
      updatedAt: article.updatedAt.toISOString(),
      author: null,
    };
    return articleData;
  }
}
