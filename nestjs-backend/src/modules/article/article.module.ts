import { Module } from '@nestjs/common';
import { AccountModule } from '../account/account.module';
import { ArticleService } from './services/article.service';
import { ArticleController } from './article.controller';
import { ArticleCommentService } from './services/article-comment.service';
import { ArticleFavoriteService } from './services/article-favorite.service';

@Module({
  imports: [AccountModule],
  providers: [ArticleService, ArticleCommentService, ArticleFavoriteService],
  controllers: [ArticleController],
})
export class ArticleModule {}
