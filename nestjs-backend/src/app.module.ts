import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ArticleModule } from './article/article.module';
import { ProfileModule } from './profile/profile.module';
import { AuthModule } from './auth/auth.module';
import TypeOrmModule from './configuration/module-import/typeorm';
import databaseConfig from './configuration/config/database.config';
import iamConfig from './configuration/config/iam.config';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, envFilePath: '.env', load: [databaseConfig, iamConfig] }),
    TypeOrmModule,
    ArticleModule,
    ProfileModule,
    AuthModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
