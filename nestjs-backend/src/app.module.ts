import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ArticleModule } from './article/article.module';
import { ProfileModule } from './profile/profile.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [ArticleModule, ProfileModule, AuthModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
