import { Module } from '@nestjs/common';
import { AccountModule } from '../account/account.module';
import { ArticleService } from './article.service';
import { ArticleController } from './article.controller';
import { ArticleCommentService } from './article-comment.service';

@Module({
  imports: [AccountModule],
  providers: [ArticleService, ArticleCommentService],
  controllers: [ArticleController],
})
export class ArticleModule {}
