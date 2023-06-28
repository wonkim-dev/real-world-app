import { Test } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DataSource, In } from 'typeorm';
import * as request from 'supertest';
import * as cookieParser from 'cookie-parser';
import { cloneDeep } from 'lodash';
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
import { Article, ArticleUserMapping, Tag, User, UserRelation } from '../../../src/entities';
import { ArticleModule } from '../../../src/modules/article/article.module';
import { ArticleData, ArticleResponse, CreateArticleDto } from '../../../src/modules/article/article.model';
import { ArticleMissingQueryStringError } from '../../../src/modules/article/article.error';

describe('Article', () => {
  let app: INestApplication;
  let dataSource: DataSource;
  let keycloakApiClientHelperService: KeycloakApiClientHelperService;
  const endpointApiArticles = '/api/articles';
  const endpointApiUsers = '/api/users';
  const endpointApiArticlesList = '/api/articles/list';
  const endpointApiArticlesFeed = '/api/articles/feed';
  const mockUser1 = { user: { email: 'e2e-test-1@email.com', password: 'e2e-test-1-password', username: 'e2e-test-1-username' } };
  const mockUser2 = { user: { email: 'e2e-test-2@email.com', password: 'e2e-test-2-password', username: 'e2e-test-2-username' } };
  const mockUser3 = { user: { email: 'e2e-test-3@email.com', password: 'e2e-test-3-password', username: 'e2e-test-3-username' } };
  let mockUser1AccessToken: string;
  let mockUser2AccessToken: string;
  let mockUser3AccessToken: string;
  let decodedAccessToken1: DecodedAccessToken;
  let decodedAccessToken2: DecodedAccessToken;
  let decodedAccessToken3: DecodedAccessToken;

  const articleInput = {
    article: {
      title: 'e2e-test-article-title',
      description: 'e2e-test-article-description',
      body: 'e2e-test-article-body',
      tagList: null,
    },
  };
  const articleTags = ['e2e-test-tag-1', 'e2e-test-tag-2'];

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
    const user2 = await request(app.getHttpServer()).post(endpointApiUsers).send(mockUser2);
    mockUser2AccessToken = user2.body.user.accessToken;
    decodedAccessToken2 = JSON.parse(Buffer.from(mockUser2AccessToken.split('.')[1], 'base64').toString('utf8'));
    const user3 = await request(app.getHttpServer()).post(endpointApiUsers).send(mockUser3);
    mockUser3AccessToken = user3.body.user.accessToken;
    decodedAccessToken3 = JSON.parse(Buffer.from(mockUser3AccessToken.split('.')[1], 'base64').toString('utf8'));

    // User 1 follows user 2
    await dataSource.manager.save(UserRelation, { fkUserId: decodedAccessToken2.sub, followedByFkUserId: decodedAccessToken1.sub });

    const testUsers = [
      { accessToken: mockUser1AccessToken, decodedAccessToken: decodedAccessToken1 },
      { accessToken: mockUser2AccessToken, decodedAccessToken: decodedAccessToken2 },
      { accessToken: mockUser3AccessToken, decodedAccessToken: decodedAccessToken3 },
    ];

    for (const user of testUsers) {
      for (let i = 1; i <= 3; i++) {
        const tagList = i === 1 ? [articleTags[0]] : i === 2 ? [articleTags[1]] : articleTags;
        const input: CreateArticleDto = cloneDeep(articleInput);
        input.article.title += `-${user.decodedAccessToken.preferred_username}-${i}`;
        input.article.description += `-${user.decodedAccessToken.preferred_username}-${i}`;
        input.article.body += `-${user.decodedAccessToken.preferred_username}-${i}`;
        input.article.tagList = tagList;
        const res = await request(app.getHttpServer())
          .post(endpointApiArticles)
          .set('Authorization', `Bearer ${user.accessToken}`)
          .send(input);
        if (user.decodedAccessToken.preferred_username === mockUser2.user.username) {
          // User 3 favorites all articles created by user 2
          const article = await dataSource.manager.findOneBy(Article, { slug: (res.body as ArticleResponse).article.slug });
          await dataSource.manager.save(ArticleUserMapping, {
            fkArticleId: article.articleId,
            favoritedByFkUserId: decodedAccessToken3.sub,
          });
        }
      }
    }
  });

  afterAll(async () => {
    await keycloakApiClientHelperService.deleteKeycloakUser(decodedAccessToken1.sub);
    await dataSource.manager.delete(User, { userId: decodedAccessToken1.sub });
    await dataSource.manager.delete(Article, { fkUserId: decodedAccessToken1.sub });

    await keycloakApiClientHelperService.deleteKeycloakUser(decodedAccessToken2.sub);
    await dataSource.manager.delete(User, { userId: decodedAccessToken2.sub });
    await dataSource.manager.delete(Article, { fkUserId: decodedAccessToken2.sub });

    await keycloakApiClientHelperService.deleteKeycloakUser(decodedAccessToken3.sub);
    await dataSource.manager.delete(User, { userId: decodedAccessToken3.sub });
    await dataSource.manager.delete(Article, { fkUserId: decodedAccessToken3.sub });

    await dataSource.manager.delete(Tag, { name: In(articleTags) });

    await app.close();
  });

  describe('GET /api/articles/list', () => {
    describe('Positive tests', () => {
      it('should fetch recent 3 articles by author using default limit and offset', async () => {
        const res = await request(app.getHttpServer()).get(`${endpointApiArticlesList}?author=${decodedAccessToken2.preferred_username}`);

        expect(res.status).toBe(200);
        expect(res.body.articles).toHaveLength(3);
        expect(res.body.articles).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-1`),
              description: expect.stringContaining(`${articleInput.article.description}-${decodedAccessToken2.preferred_username}-1`),
              body: expect.stringContaining(`${articleInput.article.body}-${decodedAccessToken2.preferred_username}-1`),
              favorited: false,
              favoritesCount: 1,
              tagList: expect.arrayContaining([articleTags[0]]),
              author: expect.objectContaining({ username: decodedAccessToken2.preferred_username, following: false }),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-2`),
              description: expect.stringContaining(`${articleInput.article.description}-${decodedAccessToken2.preferred_username}-2`),
              body: expect.stringContaining(`${articleInput.article.body}-${decodedAccessToken2.preferred_username}-2`),
              favorited: false,
              favoritesCount: 1,
              tagList: expect.arrayContaining([articleTags[1]]),
              author: expect.objectContaining({ username: decodedAccessToken2.preferred_username, following: false }),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-3`),
              description: expect.stringContaining(`${articleInput.article.description}-${decodedAccessToken2.preferred_username}-3`),
              body: expect.stringContaining(`${articleInput.article.body}-${decodedAccessToken2.preferred_username}-3`),
              favorited: false,
              favoritesCount: 1,
              tagList: expect.arrayContaining(articleTags),
              author: expect.objectContaining({ username: decodedAccessToken2.preferred_username, following: false }),
            } as Partial<ArticleData>),
          ])
        );
      });

      it('should fetch recent one article by author using limit 3 and offset 2', async () => {
        const res = await request(app.getHttpServer()).get(
          `${endpointApiArticlesList}?author=${decodedAccessToken2.preferred_username}&limit=3&offset=2`
        );

        expect(res.status).toBe(200);
        expect(res.body.articles).toHaveLength(1);
        expect(res.body.articles).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-1`),
              description: expect.stringContaining(`${articleInput.article.description}-${decodedAccessToken2.preferred_username}-1`),
              body: expect.stringContaining(`${articleInput.article.body}-${decodedAccessToken2.preferred_username}-1`),
              favorited: false,
              favoritesCount: 1,
              tagList: expect.arrayContaining([articleTags[0]]),
              author: expect.objectContaining({ username: decodedAccessToken2.preferred_username, following: false }),
            } as Partial<ArticleData>),
          ])
        );
      });

      it('should fetch recent 6 articles by tag using default limit and offset', async () => {
        const res = await request(app.getHttpServer()).get(`${endpointApiArticlesList}?tag=${articleTags[0]}`);

        expect(res.status).toBe(200);
        expect(res.body.articles).toHaveLength(6);
        expect(res.body.articles).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken1.preferred_username}-1`),
              tagList: expect.arrayContaining([articleTags[0]]),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken1.preferred_username}-3`),
              tagList: expect.arrayContaining(articleTags),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-1`),
              tagList: expect.arrayContaining([articleTags[0]]),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-3`),
              tagList: expect.arrayContaining(articleTags),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken3.preferred_username}-1`),
              tagList: expect.arrayContaining([articleTags[0]]),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken3.preferred_username}-3`),
              tagList: expect.arrayContaining(articleTags),
            } as Partial<ArticleData>),
          ])
        );
      });

      it('should fetch recent 2 articles by tag using limit 2 and offset 4', async () => {
        const res = await request(app.getHttpServer()).get(`${endpointApiArticlesList}?tag=${articleTags[0]}&limit=2&offset=4`);

        expect(res.status).toBe(200);
        expect(res.body.articles).toHaveLength(2);
        expect(res.body.articles).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken1.preferred_username}-1`),
              tagList: expect.arrayContaining([articleTags[0]]),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken1.preferred_username}-3`),
              tagList: expect.arrayContaining(articleTags),
            } as Partial<ArticleData>),
          ])
        );
      });

      it('should fetch recent 3 articles by favoritedBy using default limit and offset', async () => {
        const res = await request(app.getHttpServer()).get(
          `${endpointApiArticlesList}?favoritedBy=${decodedAccessToken3.preferred_username}`
        );

        expect(res.status).toBe(200);
        expect(res.body.articles).toHaveLength(3);
        expect(res.body.articles).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-1`),
              tagList: expect.arrayContaining([articleTags[0]]),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-2`),
              tagList: expect.arrayContaining([articleTags[1]]),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-3`),
              tagList: expect.arrayContaining(articleTags),
            } as Partial<ArticleData>),
          ])
        );
      });

      it('should fetch recent 1 article by favoritedBy using limit 2 and offset 2', async () => {
        const res = await request(app.getHttpServer()).get(
          `${endpointApiArticlesList}?favoritedBy=${decodedAccessToken3.preferred_username}&limit=2&offset=2`
        );

        expect(res.status).toBe(200);
        expect(res.body.articles).toHaveLength(1);
        expect(res.body.articles).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-1`),
              tagList: expect.arrayContaining([articleTags[0]]),
            } as Partial<ArticleData>),
          ])
        );
      });

      it('should fetch recent 1 article by favoritedBy, tag and author using limit 1 and offset 1', async () => {
        const res = await request(app.getHttpServer()).get(
          `${endpointApiArticlesList}?favoritedBy=${decodedAccessToken3.preferred_username}&author=${decodedAccessToken2.preferred_username}&tag=${articleTags[0]}&limit=1&offset=1`
        );

        expect(res.status).toBe(200);
        expect(res.body.articles).toHaveLength(1);
        expect(res.body.articles).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-1`),
              tagList: expect.arrayContaining([articleTags[0]]),
            } as Partial<ArticleData>),
          ])
        );
      });
    });

    describe('Negative tests', () => {
      it('should fail if query string is not provided', async () => {
        const res = await request(app.getHttpServer()).get(`${endpointApiArticlesList}`);

        expect(res.status).toBe(400);
        expect(res.body).toEqual(
          expect.objectContaining({ message: ArticleMissingQueryStringError.message, error: ArticleMissingQueryStringError.code })
        );
      });
    });
  });

  describe('GET /api/articles/feed', () => {
    describe('Positive tests', () => {
      it('should fetch recent 3 articles feed using default limit and offset', async () => {
        const res = await request(app.getHttpServer())
          .get(`${endpointApiArticlesFeed}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`);

        expect(res.status).toBe(200);
        expect(res.body.articles).toHaveLength(3);
        expect(res.body.articles).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-1`),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-2`),
            } as Partial<ArticleData>),
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-2`),
            } as Partial<ArticleData>),
          ])
        );
      });

      it('should fetch recent one article feed using limit 2 and offset 2', async () => {
        const res = await request(app.getHttpServer())
          .get(`${endpointApiArticlesFeed}?limit=2&offset=2`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`);

        expect(res.status).toBe(200);
        expect(res.body.articles).toHaveLength(1);
        expect(res.body.articles).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              title: expect.stringContaining(`${articleInput.article.title}-${decodedAccessToken2.preferred_username}-1`),
            } as Partial<ArticleData>),
          ])
        );
      });
    });

    describe('Negative tests', () => {
      it('should fail if not authenticated', async () => {
        const res = await request(app.getHttpServer()).get(`${endpointApiArticlesFeed}`);

        expect(res.body).toEqual(expect.objectContaining({ statusCode: 401, message: 'Unauthorized' }));
      });
    });
  });
});
