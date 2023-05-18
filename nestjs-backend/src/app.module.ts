import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import ConfigModule from './import/config.module';
import { KeycloakModule, KeycloakProviders } from './import/keycloak.module';
import TypeOrmModule from './import/typeorm.module';
import { ArticleModule } from './modules/article/article.module';
import { AccountModule } from './modules/account/account.module';
import { AuthModule } from './modules/auth/auth.module';

@Module({
  imports: [ConfigModule, KeycloakModule, TypeOrmModule, ArticleModule, AccountModule, AuthModule],
  controllers: [AppController],
  providers: [...KeycloakProviders],
})
export class AppModule {}
