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
import { Article, Comment, Tag, User, UserRelation } from '../../../src/entities';
import { ArticleModule } from '../../../src/modules/article/article.module';
import { ArticleData } from '../../../src/modules/article/article.model';
import { ArticleCommentInvalidBodyError, ArticleNotFoundError } from '../../../src/modules/article/article.error';

describe('Article', () => {
  let app: INestApplication;
  let dataSource: DataSource;
  let keycloakApiClientHelperService: KeycloakApiClientHelperService;
  const endpointApiArticles = '/api/articles';
  const endpointApiUsers = '/api/users';
  const endpointApiArticlesComment = '/api/articles/:slug/comments';
  const mockUser1 = { user: { email: 'e2e-test-1@email.com', password: 'e2e-test-1-password', username: 'e2e-test-1-username' } };
  const mockUser2 = { user: { email: 'e2e-test-2@email.com', password: 'e2e-test-2-password', username: 'e2e-test-2-username' } };
  let mockUser1AccessToken: string;
  let mockUser2AccessToken: string;
  let decodedAccessToken1: DecodedAccessToken;
  let decodedAccessToken2: DecodedAccessToken;
  let article1Slug: string;
  let article1Id: number;
  let article2Slug: string;

  const article1Input = {
    article: {
      title: 'e2e-test-article-1-title',
      description: 'e2e-test-article-1-description',
      body: 'e2e-test-article-1-body',
      tagList: ['e2e-test-tag-1', 'e2e-test-tag-2'],
    },
  };
  const article2Input = {
    article: {
      title: 'e2e-test-article-2-title',
      description: 'e2e-test-article-2-description',
      body: 'e2e-test-article-2-body',
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

    // User 1 follows user 2
    await dataSource.manager.save(UserRelation, { fkUserId: decodedAccessToken2.sub, followedByFkUserId: decodedAccessToken1.sub });

    const res1 = await request(app.getHttpServer())
      .post(endpointApiArticles)
      .set('Authorization', `Bearer ${mockUser1AccessToken}`)
      .send(article1Input);
    article1Slug = res1.body.article.slug;
    const mockArticle1 = await dataSource.manager.findOneBy(Article, { slug: article1Slug });
    article1Id = mockArticle1.articleId;

    const res2 = await request(app.getHttpServer())
      .post(endpointApiArticles)
      .set('Authorization', `Bearer ${mockUser2AccessToken}`)
      .send(article2Input);
    article2Slug = res2.body.article.slug;
  });

  afterAll(async () => {
    await keycloakApiClientHelperService.deleteKeycloakUser(decodedAccessToken1.sub);
    await dataSource.manager.delete(User, { userId: decodedAccessToken1.sub });
    await dataSource.manager.delete(Article, { fkUserId: decodedAccessToken1.sub });

    await keycloakApiClientHelperService.deleteKeycloakUser(decodedAccessToken2.sub);
    await dataSource.manager.delete(User, { userId: decodedAccessToken2.sub });
    await dataSource.manager.delete(Article, { fkUserId: decodedAccessToken2.sub });

    await dataSource.manager.delete(Tag, { name: In(article1Input.article.tagList) });

    await app.close();
  });

  describe('POST /api/articles/:slug/comments', () => {
    const commentInput = { comment: { body: 'e2e-test-comment-body' } };

    describe('Positive tests', () => {
      afterEach(async () => {
        await dataSource.manager.delete(Comment, { fkArticleId: article1Id, fkUserId: decodedAccessToken1.sub });
      });

      it('should create a comment', async () => {
        const res = await request(app.getHttpServer())
          .post(`${endpointApiArticlesComment.replace(':slug', article1Slug)}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`)
          .send(commentInput);

        expect(res.status).toBe(201);
        expect(res.body.comment).toEqual(
          expect.objectContaining({
            body: expect.stringContaining(commentInput.comment.body),
            author: expect.objectContaining({ username: decodedAccessToken1.preferred_username, following: false }),
          } as Partial<ArticleData>)
        );
      });
    });

    describe('Negative tests', () => {
      it('should fail if not authenticated', async () => {
        const res = await request(app.getHttpServer())
          .post(`${endpointApiArticlesComment.replace(':slug', article1Slug)}`)
          .send(commentInput);

        expect(res.body).toEqual(expect.objectContaining({ statusCode: 401, message: 'Unauthorized' }));
      });

      it('should fail if comment body is invalid', async () => {
        const res = await request(app.getHttpServer())
          .post(`${endpointApiArticlesComment.replace(':slug', article1Slug)}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`)
          .send({ comment: { body: ' ' } });

        expect(res.body.statusCode).toBe(400);
        expect(res.body).toEqual(
          expect.objectContaining({ message: ArticleCommentInvalidBodyError.message, error: ArticleCommentInvalidBodyError.code })
        );
      });

      it('should fail if article does not exist', async () => {
        const invalidSlug = 'invalid-article-slug';

        const res = await request(app.getHttpServer())
          .post(`${endpointApiArticlesComment.replace(':slug', invalidSlug)}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`)
          .send(commentInput);

        expect(res.body.statusCode).toBe(404);
        expect(res.body).toEqual(expect.objectContaining({ message: ArticleNotFoundError.message, error: ArticleNotFoundError.code }));
      });
    });
  });

  describe('GET /api/articles/:slug/comments', () => {
    const comment1Input = { body: 'e2e-test-comment-1-body' };
    const comment2Input = { body: 'e2e-test-comment-2-body' };

    beforeAll(async () => {
      await dataSource.manager.save(Comment, [
        { ...comment1Input, fkArticleId: article1Id, fkUserId: decodedAccessToken1.sub },
        { ...comment2Input, fkArticleId: article1Id, fkUserId: decodedAccessToken2.sub },
      ]);
    });

    describe('Positive tests', () => {
      it('should get comments for the selected article', async () => {
        const res = await request(app.getHttpServer())
          .get(`${endpointApiArticlesComment.replace(':slug', article1Slug)}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`);

        expect(res.body.comments).toHaveLength(2);
        expect(res.body.comments).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              body: comment1Input.body,
              author: expect.objectContaining({ username: decodedAccessToken1.preferred_username }),
            }),
            expect.objectContaining({
              body: comment2Input.body,
              author: expect.objectContaining({ username: decodedAccessToken2.preferred_username }),
            }),
          ])
        );
      });

      it('should get an empty array for the selected article', async () => {
        const res = await request(app.getHttpServer())
          .get(`${endpointApiArticlesComment.replace(':slug', article2Slug)}`)
          .set('Authorization', `Bearer ${mockUser1AccessToken}`);

        expect(res.body.comments).toHaveLength(0);
      });
    });

    describe('Negative tests', () => {
      it('should fail if article does not exist', async () => {
        const invalidSlug = 'invalid-article-slug';

        const res = await request(app.getHttpServer()).get(`${endpointApiArticlesComment.replace(':slug', invalidSlug)}`);

        expect(res.body.statusCode).toBe(404);
        expect(res.body).toEqual(expect.objectContaining({ message: ArticleNotFoundError.message, error: ArticleNotFoundError.code }));
      });
    });
  });
});
