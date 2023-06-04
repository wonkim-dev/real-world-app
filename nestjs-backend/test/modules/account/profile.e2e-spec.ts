import { Test } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DataSource } from 'typeorm';
import * as request from 'supertest';
import * as cookieParser from 'cookie-parser';
import databaseConfig from '../../../src/configs/database.config';
import iamConfig from '../../../src/configs/iam.config';
import cacheConfig from '../../../src/configs/cache-store.config';
import backendConfig from '../../../src/configs/backend.config';
import objectStorageConfig from '../../../src/configs/object-storage.config';
import { AccountModule } from '../../../src/modules/account/account.module';
import { AuthModule } from '../../../src/modules/auth/auth.module';
import { KeycloakModule, KEYCLOAK_PROVIDERS } from '../../../src/import/keycloak.module';
import TypeOrmModule from '../../../src/import/typeorm.module';
import CacheModule from '../../../src/import/cache.module';
import { FileModule } from '../../../src/modules/file/file.module';
import { TestHelperModule } from '../../helper/test-helper.module';
import { DecodedAccessToken } from '../../../src/models/model';
import { KeycloakApiClientHelperService } from '../../helper/keycloak-api-client-helper.service';
import { User, UserRelation } from '../../../src/entities';
import { ProfileAlreadyFollowingError, ProfileNotFoundError } from '../../../src/modules/account/profile/profile.error';

enum NestKeycloakConnectErrorMessage {
  Unauthorized = 'Unauthorized',
}

describe('Profile', () => {
  let app: INestApplication;
  let dataSource: DataSource;
  let keycloakApiClientHelperService: KeycloakApiClientHelperService;
  const endpointApiUsers = '/api/users';
  const USER_INPUT_1 = { user: { email: 'e2e-test-1@email.com', password: 'e2e-test-password-1', username: 'e2e-test-username-1' } };
  const USER_INPUT_2 = { user: { email: 'e2e-test-2@email.com', password: 'e2e-test-password-2', username: 'e2e-test-username-2' } };
  let accessToken1: string;
  let userId1: string;
  let userId2: string;
  let username2: string;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({
          isGlobal: true,
          envFilePath: '.env.e2e',
          load: [databaseConfig, iamConfig, cacheConfig, objectStorageConfig, backendConfig],
        }),
        AccountModule,
        AuthModule,
        KeycloakModule,
        TypeOrmModule,
        CacheModule, // FIXME:  Redis client needs to be close to make Jest exit from the test correctly. Currently --forceExit is used to exit by force.
        FileModule,
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

    // Create mock user 1
    const res1 = await request(app.getHttpServer()).post(endpointApiUsers).send(USER_INPUT_1);
    accessToken1 = res1.body.user.accessToken;
    const decodedAccessToken1: DecodedAccessToken = JSON.parse(
      Buffer.from(res1.body.user.accessToken.split('.')[1], 'base64').toString('utf8')
    );
    userId1 = decodedAccessToken1.sub;
    // Create mock user 2
    const res2 = await request(app.getHttpServer()).post(endpointApiUsers).send(USER_INPUT_2);
    const decodedAccessToken2: DecodedAccessToken = JSON.parse(
      Buffer.from(res2.body.user.accessToken.split('.')[1], 'base64').toString('utf8')
    );
    userId2 = decodedAccessToken2.sub;
    username2 = decodedAccessToken2.preferred_username;
  });

  afterAll(async () => {
    // Delete created user
    await keycloakApiClientHelperService.deleteKeycloakUser(userId1);
    await dataSource.manager.delete(User, { userId: userId1 });
    await keycloakApiClientHelperService.deleteKeycloakUser(userId2);
    await dataSource.manager.delete(User, { userId: userId2 });
  });
  describe('GET /api/profiles/:username', () => {
    afterAll(async () => {
      await dataSource.manager.delete(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
    });

    describe('Positive tests', () => {
      it('should fetch a profile as unauthenticated', async () => {
        // ACT
        const res = await request(app.getHttpServer()).get(`/api/profiles/${username2}`);
        // ASSERT
        expect(res.status).toBe(200);
        expect(res.body.profile).toEqual(expect.objectContaining({ username: USER_INPUT_2.user.username, following: false, image: null }));
      });

      it('should fetch a profile whom the user does not follow', async () => {
        // ACT
        const res = await request(app.getHttpServer()).get(`/api/profiles/${username2}`).set('Authorization', `Bearer ${accessToken1}`);
        // ASSERT
        expect(res.status).toBe(200);
        expect(res.body.profile).toEqual(expect.objectContaining({ username: USER_INPUT_2.user.username, following: false, image: null }));
      });

      it('should fetch a profile whom the user follows', async () => {
        // ARRANGE
        await dataSource.manager.insert(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
        // ACT
        const res = await request(app.getHttpServer()).get(`/api/profiles/${username2}`).set('Authorization', `Bearer ${accessToken1}`);
        // ASSERT
        expect(res.status).toBe(200);
        expect(res.body.profile).toEqual(expect.objectContaining({ username: USER_INPUT_2.user.username, following: true, image: null }));
        await dataSource.manager.delete(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
      });
    });

    describe('Negative tests', () => {
      it('should fail if username does not exist', async () => {
        // ACT
        const res = await request(app.getHttpServer()).get(`/api/profiles/invalid`);
        // ASSERT
        expect(res.status).toBe(404);
        expect(res.body.error).toBe(ProfileNotFoundError.code);
        await dataSource.manager.delete(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
      });
    });
  });

  describe('POST /api/profiles/:username/follow', () => {
    afterAll(async () => {
      await dataSource.manager.delete(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
    });

    describe('Positive tests', () => {
      it('should follow a new profile', async () => {
        // ACT
        const res = await request(app.getHttpServer())
          .post(`/api/profiles/${username2}/follow`)
          .set('Authorization', `Bearer ${accessToken1}`);
        // ASSERT
        expect(res.status).toBe(201);
        expect(res.body.profile).toEqual(expect.objectContaining({ username: USER_INPUT_2.user.username, following: true, image: null }));
        await dataSource.manager.delete(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
      });
    });

    describe('Negative tests', () => {
      it('should fail if authenticated user already follows the profile', async () => {
        // ARRANGE
        await dataSource.manager.insert(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
        // ACT
        const res = await request(app.getHttpServer())
          .post(`/api/profiles/${username2}/follow`)
          .set('Authorization', `Bearer ${accessToken1}`);
        // ASSERT
        expect(res.status).toBe(409);
        expect(res.body.error).toBe(ProfileAlreadyFollowingError.code);
        await dataSource.manager.delete(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
      });

      it('should fail if not authenticated', async () => {
        // ARRANGE
        await dataSource.manager.insert(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
        // ACT
        const res = await request(app.getHttpServer()).post(`/api/profiles/${username2}/follow`);
        // ASSERT
        expect(res.status).toBe(401);
        expect(res.body.message).toBe(NestKeycloakConnectErrorMessage.Unauthorized);
      });
    });
  });

  describe('DELETE /api/profiles/:username/unfollow', () => {
    afterAll(async () => {
      await dataSource.manager.delete(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
    });

    describe('Positive tests', () => {
      it('should unfollow a profile', async () => {
        // ARRANGE
        await dataSource.manager.insert(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
        // ACT
        const res = await request(app.getHttpServer())
          .delete(`/api/profiles/${username2}/unfollow`)
          .set('Authorization', `Bearer ${accessToken1}`);
        // ASSERT
        expect(res.status).toBe(200);
        expect(res.body.profile).toEqual(expect.objectContaining({ username: USER_INPUT_2.user.username, following: false, image: null }));
      });
    });

    describe('Negative tests', () => {
      it('should fail if not authenticated', async () => {
        // ARRANGE
        await dataSource.manager.insert(UserRelation, { fkUserId: userId2, followedByFkUserId: userId1 });
        // ACT
        const res = await request(app.getHttpServer()).delete(`/api/profiles/${username2}/unfollow`);
        // ASSERT
        expect(res.status).toBe(401);
        expect(res.body.message).toBe(NestKeycloakConnectErrorMessage.Unauthorized);
      });
    });
  });

  afterAll(async () => {
    await app.close();
  });
});
