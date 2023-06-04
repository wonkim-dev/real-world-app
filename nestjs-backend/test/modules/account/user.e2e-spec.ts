import { Test } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DataSource } from 'typeorm';
import * as request from 'supertest';
import * as cookieParser from 'cookie-parser';
import { cloneDeep } from 'lodash';
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
import { DecodedAccessToken, DecodedRefreshToken } from '../../../src/models/model';
import { KeycloakApiClientHelperService } from '../../helper/keycloak-api-client-helper.service';
import { User } from '../../../src/entities';
import { UserInvalidRefreshTokenError, UserMissingRefreshTokenError } from '../../../src/modules/account/user/user.error';

enum KeycloakAdminApiErrorMessage {
  UserNameExists = 'User exists with same username',
  EmailExists = 'User exists with same email',
  InvalidUserCredentials = 'Invalid user credentials',
}

enum KeycloakAdminApiErrorCode {
  InvalidPassword = 'invalid_password',
}

enum NestKeycloakConnectErrorMessage {
  Unauthorized = 'Unauthorized',
}

enum ClassValidatorErrorMessage {
  InvalidEmail = 'user.email must be an email',
  EmptyPassword = 'user.password should not be empty',
}

describe('User', () => {
  let app: INestApplication;
  let dataSource: DataSource;
  let keycloakApiClientHelperService: KeycloakApiClientHelperService;
  const endpointApiUsers = '/api/users';
  const endpointApiUsersLogin = '/api/users/login';
  const endpointApiUsersPassword = '/api/users/password';
  const endpointApiUsersRefresh = '/api/users/refresh';

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
  });

  describe('POST /api/users', () => {
    const USER_INPUT = { user: { email: 'e2e-test@email.com', password: 'e2e-test-password', username: 'e2e-test-username' } };
    let userId: string;

    describe('Positive tests', () => {
      afterEach(async () => {
        // Delete created user
        await keycloakApiClientHelperService.deleteKeycloakUser(userId);
        await dataSource.manager.delete(User, { userId });
      });

      it('should create a new user with all fields', async () => {
        // ACT
        const res = await request(app.getHttpServer()).post(endpointApiUsers).send(USER_INPUT);
        // ASSERT
        const decodedAccessToken: DecodedAccessToken = JSON.parse(
          Buffer.from(res.body.user.accessToken.split('.')[1], 'base64').toString('utf8')
        );
        expect(res.status).toBe(201);
        expect(res.body.user).toEqual(expect.objectContaining({ email: USER_INPUT.user.email, username: USER_INPUT.user.username }));
        expect(decodedAccessToken.email).toBe(USER_INPUT.user.email);
        expect(decodedAccessToken.preferred_username).toBe(USER_INPUT.user.username);
        userId = decodedAccessToken.sub;
      });
    });

    describe('Negative tests', () => {
      const inputForNegativeTest = {
        user: {
          email: 'e2e-test-negative@email.com',
          password: 'e2e-test-negative-password',
          username: 'e2e-test-negative-username',
        },
      };

      beforeAll(async () => {
        // Create a mock user
        const res = await request(app.getHttpServer()).post('/api/users').send(USER_INPUT);
        const decodedAccessToken: DecodedAccessToken = JSON.parse(
          Buffer.from(res.body.user.accessToken.split('.')[1], 'base64').toString('utf8')
        );
        userId = decodedAccessToken.sub;
      });

      afterAll(async () => {
        // Delete mock user
        await keycloakApiClientHelperService.deleteKeycloakUser(userId);
        await dataSource.manager.delete(User, { userId });
      });

      it('should fail if username already exist', async () => {
        // ARRANGE
        const body = cloneDeep(inputForNegativeTest);
        body.user.username = USER_INPUT.user.username;
        // ACT
        const res = await request(app.getHttpServer()).post(endpointApiUsers).send(body);
        // ASSERT
        expect(res.status).toBe(409);
        expect(res.body.errorMessage).toBe(KeycloakAdminApiErrorMessage.UserNameExists);
      });

      it('should fail if email already exist', async () => {
        // ARRANGE
        const body = cloneDeep(inputForNegativeTest);
        body.user.email = USER_INPUT.user.email;
        // ACT
        const res = await request(app.getHttpServer()).post(endpointApiUsers).send(body);
        // ASSERT
        expect(res.status).toBe(409);
        expect(res.body.errorMessage).toBe(KeycloakAdminApiErrorMessage.EmailExists);
      });

      it('should fail if email is invalid', async () => {
        // ARRANGE
        const body = cloneDeep(inputForNegativeTest);
        body.user.email = 'invalidEmail';
        // ACT
        const res = await request(app.getHttpServer()).post(endpointApiUsers).send(body);
        // ASSERT
        expect(res.status).toBe(400);
        expect(res.body.message).toEqual(expect.arrayContaining([ClassValidatorErrorMessage.InvalidEmail]));
      });

      it('should fail if required field (password) is missing', async () => {
        // ARRANGE
        const body = { user: { username: inputForNegativeTest.user.username, email: inputForNegativeTest.user.email } };
        // ACT
        const res = await request(app.getHttpServer()).post(endpointApiUsers).send(body);
        // ASSERT
        expect(res.status).toBe(400);
        expect(res.body.message).toEqual(expect.arrayContaining([ClassValidatorErrorMessage.EmptyPassword]));
      });

      it('should fail if required field (password) is null', async () => {
        // ARRANGE
        const body = { user: { username: inputForNegativeTest.user.username, email: inputForNegativeTest.user.email, password: null } };
        // ACT
        const res = await request(app.getHttpServer()).post(endpointApiUsers).send(body);
        // ASSERT
        expect(res.status).toBe(400);
        expect(res.body.message).toEqual(expect.arrayContaining([ClassValidatorErrorMessage.EmptyPassword]));
      });
    });
  });

  describe('GET /api/users', () => {
    const USER_INPUT = { user: { email: 'e2e-test@email.com', password: 'e2e-test-password', username: 'e2e-test-username' } };
    let accessToken: string;
    let userId: string;

    beforeAll(async () => {
      // Create a mock user
      const res = await request(app.getHttpServer()).post(endpointApiUsers).send(USER_INPUT);
      accessToken = res.body.user.accessToken;
      const decodedAccessToken: DecodedAccessToken = JSON.parse(
        Buffer.from(res.body.user.accessToken.split('.')[1], 'base64').toString('utf8')
      );
      userId = decodedAccessToken.sub;
    });

    afterAll(async () => {
      // Delete mock user
      await keycloakApiClientHelperService.deleteKeycloakUser(userId);
      await dataSource.manager.delete(User, { userId });
    });

    describe('Positive tests', () => {
      it('should get a current user', async () => {
        // ACT
        const res = await request(app.getHttpServer()).get(endpointApiUsers).set('Authorization', `Bearer ${accessToken}`);
        // ASSERT
        expect(res.status).toBe(200);
        expect(res.body.user.email).toBe(USER_INPUT.user.email);
        expect(res.body.user.accessToken).toBe(accessToken);
      });
    });

    describe('Negative tests', () => {
      it('should fail if authorization header is missing', async () => {
        // ACT
        const res = await request(app.getHttpServer()).get(endpointApiUsers);
        // ASSERT
        expect(res.status).toBe(401);
        expect(res.body.message).toBe(NestKeycloakConnectErrorMessage.Unauthorized);
      });

      it('should fail if access token is invalid', async () => {
        // ACT
        const res = await request(app.getHttpServer()).get(endpointApiUsers).set('Authorization', `Bearer invalidToken`);
        // ASSERT
        expect(res.status).toBe(401);
        expect(res.body.message).toBe(NestKeycloakConnectErrorMessage.Unauthorized);
      });
    });
  });

  describe('PATCH /api/users', () => {
    const USER_INPUT_1 = { user: { email: 'e2e-test-1@email.com', password: 'e2e-test-password-1', username: 'e2e-test-username-1' } };
    const USER_INPUT_2 = { user: { email: 'e2e-test-2@email.com', password: 'e2e-test-password-2', username: 'e2e-test-username-2' } };
    let accessToken1: string;
    let userId1: string;
    let userId2: string;

    describe('Positive tests', () => {
      beforeEach(async () => {
        // Create a mock user
        const res = await request(app.getHttpServer()).post(endpointApiUsers).send(USER_INPUT_1);
        accessToken1 = res.body.user.accessToken;
        const decodedAccessToken1: DecodedAccessToken = JSON.parse(
          Buffer.from(res.body.user.accessToken.split('.')[1], 'base64').toString('utf8')
        );
        userId1 = decodedAccessToken1.sub;
      });

      afterEach(async () => {
        // Delete mock user
        await keycloakApiClientHelperService.deleteKeycloakUser(userId1);
        await dataSource.manager.delete(User, { userId: userId1 });
      });

      it('should update user information', async () => {
        // ARRANGE
        const body = { username: 'e2e-test-username-update', bio: 'e2e-test-bio-update' };
        // ACT
        const res = await request(app.getHttpServer()).patch(endpointApiUsers).set('Authorization', `Bearer ${accessToken1}`).send(body);
        // ASSERT
        expect(res.status).toBe(200);
        expect(res.body.user).toEqual(expect.objectContaining(body));
        const decodedAccessToken: DecodedAccessToken = JSON.parse(
          Buffer.from(res.body.user.accessToken.split('.')[1], 'base64').toString('utf8')
        );
        expect(decodedAccessToken.preferred_username).toBe(body.username);
      });

      // TODO: Write another positive test to upload a avatar
    });

    describe('Negative tests', () => {
      beforeAll(async () => {
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
      });

      afterAll(async () => {
        // Delete mock users
        await keycloakApiClientHelperService.deleteKeycloakUser(userId1);
        await dataSource.manager.delete(User, { userId: userId1 });
        await keycloakApiClientHelperService.deleteKeycloakUser(userId2);
        await dataSource.manager.delete(User, { userId: userId2 });
      });

      it('should fail if username already exists', async () => {
        // ARRANGE
        const body = { username: USER_INPUT_2.user.username, bio: 'new-e2e-test-bio' };
        // ACT: Update username of user 1 to the same username of user 2
        const res = await request(app.getHttpServer()).patch(endpointApiUsers).set('Authorization', `Bearer ${accessToken1}`).send(body);
        // ASSERT
        expect(res.status).toBe(409);
      });

      it('should fail if access token is invalid', async () => {
        // ARRANGE
        const body = { username: USER_INPUT_2.user.username, bio: 'new-e2e-test-bio' };
        // ACT
        const res = await request(app.getHttpServer()).patch(endpointApiUsers).set('Authorization', `Bearer invalidToken`).send(body);
        // ASSERT
        expect(res.status).toBe(401);
        expect(res.body.message).toBe(NestKeycloakConnectErrorMessage.Unauthorized);
      });

      it('should fail if access token is missing', async () => {
        // ARRANGE
        const body = { username: USER_INPUT_2.user.username, bio: 'new-e2e-test-bio' };
        // ACT
        const res = await request(app.getHttpServer()).patch(endpointApiUsers).send(body);
        // ASSERT
        expect(res.status).toBe(401);
        expect(res.body.message).toBe(NestKeycloakConnectErrorMessage.Unauthorized);
      });
    });
  });

  describe('POST /api/users/login', () => {
    const USER_INPUT = { user: { email: 'e2e-test@email.com', password: 'e2e-test-password', username: 'e2e-test-username' } };
    let userId: string;
    let accessToken: string;

    describe('Positive tests', () => {
      // Create a mock user
      beforeAll(async () => {
        const res = await request(app.getHttpServer()).post(endpointApiUsers).send(USER_INPUT);
        accessToken = res.body.user.accessToken;
        const decodedAccessToken: DecodedAccessToken = JSON.parse(Buffer.from(accessToken.split('.')[1], 'base64').toString('utf8'));
        userId = decodedAccessToken.sub;
      });

      afterAll(async () => {
        // Delete mock user
        await keycloakApiClientHelperService.deleteKeycloakUser(userId);
        await dataSource.manager.delete(User, { userId: userId });
      });

      it('should login a user', async () => {
        // ARRANGE
        const body = { user: { email: USER_INPUT.user.email, password: USER_INPUT.user.password } };
        // ACT
        const res = await request(app.getHttpServer()).post(endpointApiUsersLogin).send(body);
        // ASSERT
        expect(res.status).toBe(200);
        expect(res.body.user).toEqual(expect.objectContaining({ email: USER_INPUT.user.email, username: USER_INPUT.user.username }));
      });
    });

    describe('Negative tests', () => {
      // Create a mock user
      beforeAll(async () => {
        const res = await request(app.getHttpServer()).post(endpointApiUsers).send(USER_INPUT);
        accessToken = res.body.user.accessToken;
        const decodedAccessToken: DecodedAccessToken = JSON.parse(Buffer.from(accessToken.split('.')[1], 'base64').toString('utf8'));
        userId = decodedAccessToken.sub;
      });

      // Delete mock user
      afterAll(async () => {
        await keycloakApiClientHelperService.deleteKeycloakUser(userId);
        await dataSource.manager.delete(User, { userId: userId });
      });

      it('should fail with wrong password', async () => {
        // ARRANGE
        const body = { user: { email: USER_INPUT.user.email, password: 'wrongPassword' } };
        // ACT
        const res = await request(app.getHttpServer()).post(endpointApiUsersLogin).send(body);
        // ASSERT
        expect(res.status).toBe(401);
        expect(res.body.error_description).toBe(KeycloakAdminApiErrorMessage.InvalidUserCredentials);
      });

      it('should fail with missing password', async () => {
        // ARRANGE
        const body = { user: { email: USER_INPUT.user.email } };
        // ACT
        const res = await request(app.getHttpServer()).post(endpointApiUsersLogin).send(body);
        // ASSERT
        expect(res.status).toBe(400);
        expect(res.body.message).toEqual(expect.arrayContaining([ClassValidatorErrorMessage.EmptyPassword]));
      });
    });
  });

  describe('PATCH /api/users/password', () => {
    const USER_INPUT = { user: { email: 'e2e-test@email.com', password: 'e2e-test-password', username: 'e2e-test-username' } };
    let userId: string;
    let accessToken: string;

    describe('Positive tests', () => {
      // Create a mock user
      beforeEach(async () => {
        const res = await request(app.getHttpServer()).post(endpointApiUsers).send(USER_INPUT);
        accessToken = res.body.user.accessToken;
        const decodedAccessToken: DecodedAccessToken = JSON.parse(Buffer.from(accessToken.split('.')[1], 'base64').toString('utf8'));
        userId = decodedAccessToken.sub;
      });

      afterEach(async () => {
        // Delete mock user
        await keycloakApiClientHelperService.deleteKeycloakUser(userId);
        await dataSource.manager.delete(User, { userId: userId });
      });

      it('should change password', async () => {
        // ARRANGE
        const body = { user: { oldPassword: USER_INPUT.user.password, newPassword: 'newPassword' } };
        // ACT
        const res = await request(app.getHttpServer())
          .patch(endpointApiUsersPassword)
          .set('Authorization', `Bearer ${accessToken}`)
          .send(body);
        // ASSERT
        expect(res.status).toBe(200);
        expect(res.body.user).toEqual(expect.objectContaining({ email: USER_INPUT.user.email, username: USER_INPUT.user.username }));
      });
    });

    describe('Negative tests', () => {
      // Create a mock user
      beforeAll(async () => {
        const res = await request(app.getHttpServer()).post(endpointApiUsers).send(USER_INPUT);
        accessToken = res.body.user.accessToken;
        const decodedAccessToken: DecodedAccessToken = JSON.parse(Buffer.from(accessToken.split('.')[1], 'base64').toString('utf8'));
        userId = decodedAccessToken.sub;
      });

      afterAll(async () => {
        // Delete mock user
        await keycloakApiClientHelperService.deleteKeycloakUser(userId);
        await dataSource.manager.delete(User, { userId: userId });
      });

      it('should fail with wrong old password', async () => {
        // ARRANGE
        const body = { user: { oldPassword: 'wrongPassword', newPassword: 'newPassword' } };
        // ACT
        const res = await request(app.getHttpServer())
          .patch(endpointApiUsersPassword)
          .set('Authorization', `Bearer ${accessToken}`)
          .send(body);
        // ASSERT
        expect(res.status).toBe(401);
        expect(res.body.error).toBe(KeycloakAdminApiErrorCode.InvalidPassword);
      });

      it('should fail with missing old password', async () => {
        // ARRANGE
        const body = { user: { newPassword: 'newPassword' } };
        // ACT
        const res = await request(app.getHttpServer())
          .patch(endpointApiUsersPassword)
          .set('Authorization', `Bearer ${accessToken}`)
          .send(body);
        // ASSERT
        expect(res.status).toBe(400);
      });

      it('should fail with missing new password', async () => {
        // ARRANGE
        const body = { user: { oldPassword: 'oldPassword' } };
        // ACT
        const res = await request(app.getHttpServer())
          .patch(endpointApiUsersPassword)
          .set('Authorization', `Bearer ${accessToken}`)
          .send(body);
        // ASSERT
        expect(res.status).toBe(400);
      });
    });
  });

  describe('POST /api/users/refresh', () => {
    const USER_INPUT = { user: { email: 'e2e-test@email.com', password: 'e2e-test-password', username: 'e2e-test-username' } };
    let userId: string;
    let accessToken: string;

    // Create a mock user
    beforeAll(async () => {
      const res = await request(app.getHttpServer()).post(endpointApiUsers).send(USER_INPUT);
      accessToken = res.body.user.accessToken;
      const decodedAccessToken: DecodedRefreshToken = JSON.parse(Buffer.from(accessToken.split('.')[1], 'base64').toString('utf8'));
      userId = decodedAccessToken.sub;
    });

    afterAll(async () => {
      // Delete mock user
      await keycloakApiClientHelperService.deleteKeycloakUser(userId);
      await dataSource.manager.delete(User, { userId: userId });
    });

    describe('Positive tests', () => {
      it('should get a new token using refresh token', async () => {
        // ARRANGE
        const agent = request.agent(app.getHttpServer());
        const loginResult = await agent
          .post('/api/users/login')
          .send({ user: { email: USER_INPUT.user.email, password: USER_INPUT.user.password } });
        const loginDecodedAccessToken: DecodedAccessToken = JSON.parse(
          Buffer.from(loginResult.body.user.accessToken.split('.')[1], 'base64').toString('utf8')
        );
        const body = { sessionId: loginDecodedAccessToken.sid };
        // ACT
        const res = await agent.post(endpointApiUsersRefresh).send(body);
        // ASSERT
        expect(res.status).toBe(200);
        expect(res.body.user).toEqual(expect.objectContaining({ email: USER_INPUT.user.email, username: USER_INPUT.user.username }));
      });
    });

    describe('Negative tests', () => {
      it('should fail if refresh token is missing in the request', async () => {
        // ARRANGE
        const loginResult = await request(app.getHttpServer())
          .post('/api/users/login')
          .send({ user: { email: USER_INPUT.user.email, password: USER_INPUT.user.password } });
        const loginDecodedAccessToken: DecodedAccessToken = JSON.parse(
          Buffer.from(loginResult.body.user.accessToken.split('.')[1], 'base64').toString('utf8')
        );
        const body = { sessionId: loginDecodedAccessToken.sid };
        try {
          // ACT
          await request(app.getHttpServer()).post(endpointApiUsersRefresh).send(body);
        } catch (error) {
          // ASSERT
          expect(error).toBeInstanceOf(UserMissingRefreshTokenError);
          expect(error.body.code).toEqual(UserMissingRefreshTokenError.code);
        }
      });

      it('should fail if session id in the body is invalid', async () => {
        // ARRANGE
        const agent = request.agent(app.getHttpServer());
        await agent.post('/api/users/login').send({ user: { email: USER_INPUT.user.email, password: USER_INPUT.user.password } });
        const body = { sessionId: 'invalidSessionId' };
        try {
          // ACT
          await agent.post(endpointApiUsersRefresh).send(body);
        } catch (error) {
          // ASSERT
          expect(error).toBeInstanceOf(UserInvalidRefreshTokenError);
          expect(error.body.code).toEqual(UserInvalidRefreshTokenError.code);
        }
      });
    });
  });

  afterAll(async () => {
    await app.close();
  });
});
