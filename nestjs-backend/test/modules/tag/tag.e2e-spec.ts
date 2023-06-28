import { Test } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DataSource, In } from 'typeorm';
import * as request from 'supertest';
import * as cookieParser from 'cookie-parser';
import databaseConfig from '../../../src/configs/database.config';
import iamConfig from '../../../src/configs/iam.config';
import cacheConfig from '../../../src/configs/cache-store.config';
import backendConfig from '../../../src/configs/backend.config';
import objectStorageConfig from '../../../src/configs/object-storage.config';
import { AccountModule } from '../../../src/modules/account/account.module';
import { KeycloakModule, KEYCLOAK_PROVIDERS } from '../../../src/import/keycloak.module';
import TypeOrmModule from '../../../src/import/typeorm.module';
import CacheModule from '../../../src/import/cache.module';
import { TestHelperModule } from '../../helper/test-helper.module';
import { DecodedAccessToken } from '../../../src/models/model';
import { KeycloakApiClientHelperService } from '../../helper/keycloak-api-client-helper.service';
import { Article, Tag, User } from '../../../src/entities';
import { ArticleModule } from '../../../src/modules/article/article.module';
import { TagModule } from '../../../src/modules/tag/tag.module';

describe('Article', () => {
  let app: INestApplication;
  let dataSource: DataSource;
  let keycloakApiClientHelperService: KeycloakApiClientHelperService;
  const endpointApiArticles = '/api/articles';
  const endpointApiUsers = '/api/users';
  const mockUser1 = { user: { email: 'e2e-test-1@email.com', password: 'e2e-test-1-password', username: 'e2e-test-1-username' } };
  let mockUser1AccessToken: string;
  let decodedAccessToken1: DecodedAccessToken;
  let article1Slug: string;

  const article1Input = {
    article: {
      title: 'e2e-test-article-1-title',
      description: 'e2e-test-article-1-description',
      body: 'e2e-test-article-1-body',
      tagList: ['e2e-test-tag-1', 'e2e-test-tag-2'],
    },
  };

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({
          isGlobal: true,
          envFilePath: '.env.e2e',
          load: [databaseConfig, iamConfig, cacheConfig, objectStorageConfig, backendConfig],
        }),
        KeycloakModule,
        TypeOrmModule,
        CacheModule, // FIXME:  Redis client needs to be close to make Jest exit from the test correctly. Currently --forceExit is used to exit by force.
        AccountModule,
        ArticleModule,
        TestHelperModule,
        TagModule,
      ],
      providers: [...KEYCLOAK_PROVIDERS],
    }).compile();
    app = moduleRef.createNestApplication();
    app.useGlobalPipes(new ValidationPipe());
    app.use(cookieParser());
    app.setGlobalPrefix('api');
    await app.init();

    dataSource = moduleRef.get(DataSource);
    keycloakApiClientHelperService = moduleRef.get(KeycloakApiClientHelperService);

    // Create mock users
    const user1 = await request(app.getHttpServer()).post(endpointApiUsers).send(mockUser1);
    mockUser1AccessToken = user1.body.user.accessToken;
    decodedAccessToken1 = JSON.parse(Buffer.from(mockUser1AccessToken.split('.')[1], 'base64').toString('utf8'));

    const res1 = await request(app.getHttpServer())
      .post(endpointApiArticles)
      .set('Authorization', `Bearer ${mockUser1AccessToken}`)
      .send(article1Input);
    article1Slug = res1.body.article.slug;
  });

  afterAll(async () => {
    await keycloakApiClientHelperService.deleteKeycloakUser(decodedAccessToken1.sub);
    await dataSource.manager.delete(User, { userId: decodedAccessToken1.sub });
    await dataSource.manager.delete(Article, { slug: article1Slug });
    await dataSource.manager.delete(Tag, { name: In(article1Input.article.tagList) });

    await app.close();
  });

  describe('GET /api/tags', () => {
    describe('Positive tests', () => {
      it('should get tag list', async () => {
        const res = await request(app.getHttpServer()).get('/api/tags');

        expect(res.status).toBe(200);
        expect(res.body.tags).toEqual(expect.arrayContaining(article1Input.article.tagList));
      });
    });
  });
});
