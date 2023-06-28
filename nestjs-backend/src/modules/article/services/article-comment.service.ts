import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Article, Comment } from '../../../entities';
import { DecodedAccessToken } from '../../../models/model';
import { CommentData, CreateCommentInput } from '../article.model';
import { ArticleCommentInvalidBodyError, ArticleNotFoundError } from '../article.error';
import { ProfileService } from '../../account/profile/profile.service';

@Injectable()
export class ArticleCommentService {
  constructor(private dataSource: DataSource, private profileService: ProfileService) {}

  async createComment(decodedAccessToken: DecodedAccessToken, slug: string, createCommentInput: CreateCommentInput): Promise<CommentData> {
    if (!createCommentInput.body.trim()) {
      throw new ArticleCommentInvalidBodyError();
    }
    const article = await this.dataSource.manager.findOne(Article, { where: { slug }, relations: { userByFkUserId: true } });
    if (!article) {
      throw new ArticleNotFoundError();
    }
    const commentInsertPayload = {
      body: createCommentInput.body,
      fkArticleId: article.articleId,
      fkUserId: decodedAccessToken.sub,
    } as Partial<Comment>;
    const comment = await this.dataSource.manager.save(Comment, commentInsertPayload);
    const author = await this.profileService.getProfile(decodedAccessToken.preferred_username);
    return {
      id: comment.commentId,
      body: comment.body,
      createdAt: comment.createdAt.toISOString(),
      updatedAt: comment.updatedAt.toISOString(),
      author,
    };
  }

  async getComments(decodedAccessToken: DecodedAccessToken, slug: string): Promise<CommentData[]> {
    const article = await this.dataSource.manager.findOneBy(Article, { slug });
    if (!article) {
      throw new ArticleNotFoundError();
    }
    const comments = await this.dataSource.manager.find(Comment, {
      where: { fkArticleId: article.articleId },
      relations: { userByFkUserId: true },
    });
    return await this.buildCommentsResponse(comments, decodedAccessToken);
  }

  private async buildCommentsResponse(comments: Comment[], decodedAccessToken: DecodedAccessToken): Promise<CommentData[]> {
    const commentsResponse: CommentData[] = [];
    for (const comment of comments) {
      const author = await this.profileService.getProfile(comment.userByFkUserId.username, decodedAccessToken);
      commentsResponse.push({
        id: comment.commentId,
        body: comment.body,
        createdAt: comment.createdAt.toISOString(),
        updatedAt: comment.updatedAt.toISOString(),
        author,
      });
    }
    return commentsResponse;
  }
}
