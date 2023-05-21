import { Test } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DataSource } from 'typeorm';
import * as request from 'supertest';
import databaseConfig from '../../../src/configs/database.config';
import iamConfig from '../../../src/configs/iam.config';
import cacheConfig from '../../../src/configs/cache-store.config';
import { AccountModule } from '../../../src/modules/account/account.module';
import { AuthModule } from '../../../src/modules/auth/auth.module';
import { KeycloakModule, KeycloakProviders } from '../../../src/import/keycloak.module';
import TypeOrmModule from '../../../src/import/typeorm.module';
import CacheModule from '../../../src/import/cache.module';
import { HelperModule } from '../../helper/modules/helper.module';
import { DecodedAccessToken } from '../../../src/models/model';
import { KeycloakApiClientHelperService } from '../../helper/modules/keycloak-api-client-helper.service';
import { User } from '../../../src/entities';

enum KeycloakApiErrorMessage {
  UserNameExists = 'User exists with same username',
  EmailExists = 'User exists with same email',
  Unauthorized = 'Unauthorized',
}

enum ClassValidatorErrorMessage {
  InvalidEmail = 'email must be an email',
  EmptyPassword = 'password should not be empty',
}

describe('User', () => {
  let app: INestApplication;
  let dataSource: DataSource;
  let keycloakApiClientHelperService: KeycloakApiClientHelperService;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({
          isGlobal: true,
          envFilePath: '.env.e2e',
          load: [databaseConfig, iamConfig, cacheConfig],
        }),
        AccountModule,
        AuthModule,
        KeycloakModule,
        TypeOrmModule,
        CacheModule, // FIXME:  Redis client needs to be close to make Jest exit from the test correctly. Currently --forceExit is used to exit by force.
        HelperModule,
      ],
      providers: [...KeycloakProviders],
    }).compile();
    app = moduleRef.createNestApplication();
    app.useGlobalPipes(new ValidationPipe());
    await app.init();

    dataSource = moduleRef.get(DataSource);
    keycloakApiClientHelperService = moduleRef.get(KeycloakApiClientHelperService);
  });

  describe('POST /api/users', () => {
    const endpoint = '/api/users';
    const USER_INPUT = { email: 'e2e-test@email.com', password: 'e2e-test-password', username: 'e2e-test-username' };
    let userId: string;

    afterAll(async () => {
      await keycloakApiClientHelperService.deleteKeycloakUser(userId);
      await dataSource.manager.delete(User, { userId });
    });

    describe('Positive tests', () => {
      it('should create a new user', async () => {
        // ACT
        const res = await request(app.getHttpServer()).post(endpoint).send(USER_INPUT);
        // ASSERT
        const decodedAccessToken: DecodedAccessToken = JSON.parse(
          Buffer.from(res.body.accessToken.split('.')[1], 'base64').toString('utf8')
        );
        expect(res.status).toBe(201);
        expect(res.body).toEqual(expect.objectContaining({ email: USER_INPUT.email, username: USER_INPUT.username }));
        expect(decodedAccessToken.email).toBe(USER_INPUT.email);
        expect(decodedAccessToken.preferred_username).toBe(USER_INPUT.username);
        userId = decodedAccessToken.sub;
      });
    });

    describe('Negative tests', () => {
      const inputForNegativeTest = {
        email: 'e2e-test-negative@email.com',
        password: 'e2e-test-negative-password',
        username: 'e2e-test-negative-username',
      };

      it('should fail if username already exist', async () => {
        // ARRANGE
        const body = { ...inputForNegativeTest, username: USER_INPUT.username };
        // ACT
        const res = await request(app.getHttpServer()).post(endpoint).send(body);
        // ASSERT
        expect(res.status).toBe(409);
        expect(res.body.errorMessage).toBe(KeycloakApiErrorMessage.UserNameExists);
      });

      it('should fail if email already exist', async () => {
        // ARRANGE
        const body = { ...inputForNegativeTest, email: USER_INPUT.email };
        // ACT
        const res = await request(app.getHttpServer()).post(endpoint).send(body);
        // ASSERT
        expect(res.status).toBe(409);
        expect(res.body.errorMessage).toBe(KeycloakApiErrorMessage.EmailExists);
      });

      it('should fail if email is invalid', async () => {
        // ARRANGE
        const body = { ...inputForNegativeTest, email: 'invalidEmail' };
        // ACT
        const res = await request(app.getHttpServer()).post(endpoint).send(body);
        // ASSERT
        expect(res.status).toBe(400);
        expect(res.body.message).toEqual(expect.arrayContaining([ClassValidatorErrorMessage.InvalidEmail]));
      });

      it('should fail if required field is missing', async () => {
        // ARRANGE
        const body = { username: inputForNegativeTest.username, email: inputForNegativeTest.email };
        // ACT
        const res = await request(app.getHttpServer()).post(endpoint).send(body);
        // ASSERT
        expect(res.status).toBe(400);
        expect(res.body.message).toEqual(expect.arrayContaining([ClassValidatorErrorMessage.EmptyPassword]));
      });

      it('should fail if required field is null', async () => {
        // ARRANGE
        const body = { username: inputForNegativeTest.username, email: inputForNegativeTest.email, password: null };
        // ACT
        const res = await request(app.getHttpServer()).post(endpoint).send(body);
        // ASSERT
        expect(res.status).toBe(400);
        expect(res.body.message).toEqual(expect.arrayContaining([ClassValidatorErrorMessage.EmptyPassword]));
      });
    });
  });

  describe('GET /api/users', () => {
    const endpoint = '/api/users';
    const USER_INPUT = { email: 'e2e-test@email.com', password: 'e2e-test-password', username: 'e2e-test-username' };
    let accessToken: string;
    let userId: string;

    beforeAll(async () => {
      const res = await request(app.getHttpServer()).post(endpoint).send(USER_INPUT);
      accessToken = res.body.accessToken;
      const decodedAccessToken: DecodedAccessToken = JSON.parse(Buffer.from(res.body.accessToken.split('.')[1], 'base64').toString('utf8'));
      userId = decodedAccessToken.sub;
    });

    afterAll(async () => {
      await keycloakApiClientHelperService.deleteKeycloakUser(userId);
      await dataSource.manager.delete(User, { userId });
    });

    describe('Positive tests', () => {
      it('should get a current user', async () => {
        // ACT
        const res = await request(app.getHttpServer()).get(endpoint).set('Authorization', `Bearer ${accessToken}`);
        // ASSERT
        expect(res.status).toBe(200);
        expect(res.body.email).toBe(USER_INPUT.email);
        expect(res.body.accessToken).toBe(accessToken);
      });
    });

    describe('Negative tests', () => {
      it('should fail if authorization header is missing', async () => {
        // ACT
        const res = await request(app.getHttpServer()).get(endpoint);
        // ASSERT
        expect(res.status).toBe(401);
        expect(res.body.message).toBe(KeycloakApiErrorMessage.Unauthorized);
      });

      it('should fail if access token is invalid', async () => {
        // ACT
        const res = await request(app.getHttpServer()).get(endpoint).set('Authorization', `Bearer invalidToken`);
        // ASSERT
        expect(res.status).toBe(401);
        expect(res.body.message).toBe(KeycloakApiErrorMessage.Unauthorized);
      });
    });
  });

  afterAll(async () => {
    await app.close();
  });
});
