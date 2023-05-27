import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import ConfigModule from './import/config.module';
import { KeycloakModule, KEYCLOAK_PROVIDERS } from './import/keycloak.module';
import TypeOrmModule from './import/typeorm.module';
import CacheModule from './import/cache.module';
import { ArticleModule } from './modules/article/article.module';
import { AccountModule } from './modules/account/account.module';
import { AuthModule } from './modules/auth/auth.module';
import { FileModule } from './modules/file/file.module';

@Module({
  imports: [ConfigModule, KeycloakModule, TypeOrmModule, CacheModule, ArticleModule, AccountModule, AuthModule, FileModule],
  controllers: [AppController],
  providers: [...KEYCLOAK_PROVIDERS],
})
export class AppModule {}
