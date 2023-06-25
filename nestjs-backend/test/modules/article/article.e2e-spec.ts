import { Test } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DataSource, In } from 'typeorm';
import * as request from 'supertest';
import * as cookieParser from 'cookie-parser';
import { cloneDeep, unset } from 'lodash';
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
import { ArticleData } from '../../../src/modules/article/article.model';
import {
  ArticleAccessForbiddenError,
  ArticleInputNotProvidedError,
  ArticleNotFoundError,
} from '../../../src/modules/article/article.error';

describe('Article', () => {
  let app: INestApplication;
  let dataSource: DataSource;
  let keycloakApiClientHelperService: KeycloakApiClientHelperService;
  const endpointApiArticles = '/api/articles';
  const endpointApiUsers = '/api/users';
  const mockUser1 = { user: { email: 'e2e-test-1@email.com', password: 'e2e-test-1-password', username: 'e2e-test-1-username' } };
  const mockUser2 = { user: { email: 'e2e-test-2@email.com', password: 'e2e-test-2-password', username: 'e2e-test-2-username' } };
  let mockUser1AccessToken: string;
  let mockUser2AccessToken: string;
  let decodedAccessToken1: DecodedAccessToken;
  let decodedAccessToken2: DecodedAccessToken;

  const articleInput = {
    article: {
      title: 'e2e-test-article-title',
      description: 'e2e-test-article-description',
      body: 'e2e-test-article-body',
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
  });

  describe('POST /api/articles', () => {
    const articleInput = {
      article: {
        title: 'e2e-test-article-title',
        description: 'e2e-test-article-description',
        body: 'e2e-test-article-body',
        tagList: ['e2e-test-tag-1', 'e2e-test-tag-2'],
      },
    };
    let articleSlug: string;

    describe('Positive tests', () => {
      afterEach(async () => {
        await dataSource.manager.delete(Article, { slug: articleSlug });
        await dataSource.manager.delete(Tag, { name: In(articleInput.article.tagList) });
      });

      it('should create a new article with tags', async () => {
        const res = await request(app.getHttpServer())
          .post(endpointApiArticles)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`)
          .send(articleInput);

        articleSlug = res.body.article.slug;
        expect(res.status).toBe(201);
        expect(res.body.article).toEqual(
          expect.objectContaining({
            title: articleInput.article.title,
            description: articleInput.article.description,
            body: articleInput.article.body,
            favorited: false,
            favoritesCount: 0,
            tagList: expect.arrayContaining(articleInput.article.tagList),
            author: expect.objectContaining({ username: decodedAccessToken1.preferred_username, following: false }),
          } as Partial<ArticleData>)
        );
      });

      it('should create a new article without tags', async () => {
        const articleInputCloned = cloneDeep(articleInput);
        unset(articleInputCloned, 'article.tagList');

        const res = await request(app.getHttpServer())
          .post(endpointApiArticles)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`)
          .send(articleInputCloned);

        articleSlug = res.body.article.slug;
        expect(res.status).toBe(201);
        expect(res.body.article).toEqual(
          expect.objectContaining({
            title: articleInput.article.title,
            description: articleInput.article.description,
            body: articleInput.article.body,
            favorited: false,
            favoritesCount: 0,
            tagList: [],
            author: expect.objectContaining({ username: decodedAccessToken1.preferred_username, following: false }),
          } as Partial<ArticleData>)
        );
      });
    });

    describe('Negative tests', () => {
      beforeAll(async () => {});

      afterAll(async () => {});

      it('should fail if required fields are missing', async () => {
        const articleInputCloned = cloneDeep(articleInput);
        unset(articleInputCloned, 'article.title');
        unset(articleInputCloned, 'article.body');

        const res = await request(app.getHttpServer())
          .post(endpointApiArticles)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`)
          .send(articleInputCloned);

        expect(res.body.statusCode).toBe(400);
        expect(res.body.message).toEqual(expect.arrayContaining(['article.title should not be empty', 'article.body should not be empty']));
      });

      it('should fail if the user is not authenticated', async () => {
        const res = await request(app.getHttpServer()).post(endpointApiArticles).send(articleInput);

        expect(res.body).toEqual(expect.objectContaining({ statusCode: 401, message: 'Unauthorized' }));
      });
    });
  });

  describe('GET /api/articles/:slug', () => {
    let articleSlug: string;

    beforeAll(async () => {
      const res = await request(app.getHttpServer())
        .post(endpointApiArticles)
        .set('Authorization', `Bearer ${mockUser1AccessToken}`)
        .send(articleInput);
      articleSlug = res.body.article.slug;
    });

    afterAll(async () => {
      await dataSource.manager.delete(Article, { slug: articleSlug });
      await dataSource.manager.delete(Tag, { name: In(articleInput.article.tagList) });
    });

    describe('Positive tests', () => {
      it('should fetch an article', async () => {
        const res = await request(app.getHttpServer()).get(`${endpointApiArticles}/${articleSlug}`);
        expect(res.status).toBe(200);
        expect(res.body.article).toEqual(
          expect.objectContaining({
            slug: articleSlug,
            title: articleInput.article.title,
            description: articleInput.article.description,
            body: articleInput.article.body,
            favorited: false,
            favoritesCount: 0,
            tagList: expect.arrayContaining(articleInput.article.tagList),
            author: expect.objectContaining({ username: decodedAccessToken1.preferred_username, following: false }),
          })
        );
      });
    });

    describe('Negative tests', () => {
      it('should fail if article does not exist', async () => {
        const invalidSlug = 'invalid-slug';

        const res = await request(app.getHttpServer()).get(`${endpointApiArticles}/${invalidSlug}`);

        expect(res.status).toBe(404);
        expect(res.body).toEqual(expect.objectContaining({ message: ArticleNotFoundError.message, error: ArticleNotFoundError.code }));
      });
    });
  });

  describe('PATCH /api/articles/:slug', () => {
    let articleSlug: string;
    const updateInput = {
      article: {
        description: 'e2e-test-article-description-updated',
        body: 'e2e-test-article-body-updated',
      },
    };

    beforeEach(async () => {
      const res = await request(app.getHttpServer())
        .post(endpointApiArticles)
        .set('Authorization', `Bearer ${mockUser1AccessToken}`)
        .send(articleInput);
      articleSlug = res.body.article.slug;
    });

    afterEach(async () => {
      await dataSource.manager.delete(Article, { slug: articleSlug });
      await dataSource.manager.delete(Tag, { name: In(articleInput.article.tagList) });
    });

    describe('Positive Tests', () => {
      it('should update article without title', async () => {
        const res = await request(app.getHttpServer())
          .patch(`${endpointApiArticles}/${articleSlug}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`)
          .send(updateInput);

        expect(res.status).toBe(200);
        expect(res.body.article).toEqual(
          expect.objectContaining({
            slug: articleSlug,
            title: articleInput.article.title,
            description: updateInput.article.description,
            body: updateInput.article.body,
            favorited: false,
            favoritesCount: 0,
            tagList: expect.arrayContaining(articleInput.article.tagList),
            author: expect.objectContaining({ username: decodedAccessToken1.preferred_username, following: false }),
          })
        );
      });

      it('should update article including title', async () => {
        const updateInput = {
          article: {
            title: 'e2e-test-article-title-updated',
            description: 'e2e-test-article-description-updated',
            body: 'e2e-test-article-body-updated',
          },
        };

        const res = await request(app.getHttpServer())
          .patch(`${endpointApiArticles}/${articleSlug}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`)
          .send(updateInput);

        expect(res.status).toBe(200);
        expect(res.body.article).toEqual(
          expect.objectContaining({
            slug: expect.stringContaining(updateInput.article.title),
            title: updateInput.article.title,
            description: updateInput.article.description,
            body: updateInput.article.body,
            favorited: false,
            favoritesCount: 0,
            tagList: expect.arrayContaining(articleInput.article.tagList),
            author: expect.objectContaining({ username: decodedAccessToken1.preferred_username, following: false }),
          })
        );
      });
    });

    describe('Negative tests', () => {
      it('should fail if article update input is not provided', async () => {
        const res = await request(app.getHttpServer())
          .patch(`${endpointApiArticles}/${articleSlug}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`)
          .send({});

        expect(res.body.statusCode).toBe(400);
        expect(res.body).toEqual(
          expect.objectContaining({ message: ArticleInputNotProvidedError.message, error: ArticleInputNotProvidedError.code })
        );
      });

      it('should fail if article does not exist', async () => {
        const invalidSlug = 'invalid-slug';

        const res = await request(app.getHttpServer())
          .patch(`${endpointApiArticles}/${invalidSlug}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`)
          .send(updateInput);

        expect(res.body.statusCode).toBe(404);
        expect(res.body).toEqual(expect.objectContaining({ message: ArticleNotFoundError.message, error: ArticleNotFoundError.code }));
      });

      it('should fail if the user is not authorized', async () => {
        const res = await request(app.getHttpServer())
          .patch(`${endpointApiArticles}/${articleSlug}`)
          .set('Authorization', `Bearer ${mockUser2AccessToken}`)
          .send(updateInput);

        expect(res.body.statusCode).toBe(403);
        expect(res.body).toEqual(
          expect.objectContaining({ message: ArticleAccessForbiddenError.message, error: ArticleAccessForbiddenError.code })
        );
      });

      it('should fail if the user is not authenticated', async () => {
        const res = await request(app.getHttpServer()).patch(`${endpointApiArticles}/${articleSlug}`).send(updateInput);

        expect(res.body).toEqual(expect.objectContaining({ statusCode: 401, message: 'Unauthorized' }));
      });
    });
  });

  describe('DELETE /api/articles/:slug', () => {
    let articleSlug: string;

    beforeEach(async () => {
      const res = await request(app.getHttpServer())
        .post(endpointApiArticles)
        .set('Authorization', `Bearer ${mockUser1AccessToken}`)
        .send(articleInput);
      articleSlug = res.body.article.slug;
    });

    afterEach(async () => {
      await dataSource.manager.delete(Article, { slug: articleSlug });
      await dataSource.manager.delete(Tag, { name: In(articleInput.article.tagList) });
    });

    describe('Positive tests', () => {
      it('should delete an article', async () => {
        const res = await request(app.getHttpServer())
          .delete(`${endpointApiArticles}/${articleSlug}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`);

        expect(res.status).toBe(200);
      });
    });

    describe('Negative tests', () => {
      it('should fail if article does not exist', async () => {
        const invalidSlug = 'invalid-slug';

        const res = await request(app.getHttpServer())
          .delete(`${endpointApiArticles}/${invalidSlug}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`);

        expect(res.status).toBe(404);
        expect(res.body).toEqual(expect.objectContaining({ message: ArticleNotFoundError.message, error: ArticleNotFoundError.code }));
      });

      it('should fail if the user is not authorized', async () => {
        const res = await request(app.getHttpServer())
          .delete(`${endpointApiArticles}/${articleSlug}`)
          .set('Authorization', `Bearer ${mockUser2AccessToken}`);

        expect(res.body.statusCode).toBe(403);
        expect(res.body).toEqual(
          expect.objectContaining({ message: ArticleAccessForbiddenError.message, error: ArticleAccessForbiddenError.code })
        );
      });

      it('should fail if the user is not authenticated', async () => {
        const res = await request(app.getHttpServer()).delete(`${endpointApiArticles}/${articleSlug}`);

        expect(res.body).toEqual(expect.objectContaining({ statusCode: 401, message: 'Unauthorized' }));
      });
    });
  });

  afterAll(async () => {
    await keycloakApiClientHelperService.deleteKeycloakUser(decodedAccessToken1.sub);
    await dataSource.manager.delete(User, { userId: decodedAccessToken1.sub });
    await keycloakApiClientHelperService.deleteKeycloakUser(decodedAccessToken2.sub);
    await dataSource.manager.delete(User, { userId: decodedAccessToken2.sub });
    await app.close();
  });
});
