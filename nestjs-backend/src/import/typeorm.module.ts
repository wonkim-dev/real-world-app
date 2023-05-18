import { ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Article, ArticleTagMapping, ArticleUserMapping, Comment, Tag, User, UserUserMapping } from 'src/entities';

const entities = [Article, ArticleTagMapping, ArticleUserMapping, Comment, Tag, User, UserUserMapping];

export default TypeOrmModule.forRootAsync({
  inject: [ConfigService],
  useFactory: (configService: ConfigService) => ({
    type: 'postgres',
    host: configService.get<string>('database.host'),
    port: configService.get<number>('database.port'),
    username: configService.get<string>('database.user'),
    password: configService.get<string>('database.password'),
    database: configService.get<string>('database.db'),
    synchronize: false,
    entities: [...entities],
  }),
});
