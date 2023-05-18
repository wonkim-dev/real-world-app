import { Module } from '@nestjs/common';
import { ArticleService } from './article.service';
import { ArticleController } from './article.controller';
import { ArticleCommentService } from './article-comment.service';

@Module({
  providers: [ArticleService, ArticleCommentService],
  controllers: [ArticleController],
})
export class ArticleModule {}
