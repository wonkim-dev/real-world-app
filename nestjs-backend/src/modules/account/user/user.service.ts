import { Inject, Injectable } from '@nestjs/common';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Cache } from 'cache-manager';
import { DataSource } from 'typeorm';
import { isNil, omitBy, pick } from 'lodash';
import { DateTime } from 'luxon';
import { createHash } from 'crypto';
import { DecodedAccessToken, DecodedRefreshToken } from 'src/models/model';
import { KeycloakApiClientService } from '../../auth/keycloak-api-client.service';
import { User } from '../../../entities';
import { UserInvalidPasswordError, UserRefreshTokenExpiredError } from './user.error';
import { ChangeUserPasswordInput, CreateUserInput, LoginUserInput, UpdateUserInfoInput, UserResponse } from './user.model';

@Injectable()
export class UserService {
  constructor(
    private dataSource: DataSource,
    @Inject(CACHE_MANAGER) private cacheManager: Cache,
    private keycloakApiClientService: KeycloakApiClientService
  ) {}

  /**
   * @description Create a new user account.
   * It creates a new Keycloak user and inserts a new user entity.
   * A new user session is created after successful user registration.
   * @returns Created user with access token.
   */
  async createUser(createUserInput: CreateUserInput): Promise<UserResponse> {
    await this.keycloakApiClientService.createKeycloakUser(createUserInput);
    const { username, email, password } = createUserInput;
    const { accessToken, refreshToken, sessionState } = await this.keycloakApiClientService.getUserTokenUsingPassword(username, password);
    const decodedNewRefreshToken = this.decodeToken<DecodedRefreshToken>(refreshToken);
    const ttlMilliseconds = this.calculateTtlInMillis(decodedNewRefreshToken.exp);
    const hashedNewRefreshToken = this.hashToken(refreshToken);
    await this.cacheManager.set(sessionState, hashedNewRefreshToken, ttlMilliseconds);
    const user = await this.dataSource.manager.save(User, { userId: decodedNewRefreshToken.sub, username, email });
    return this.buildUserResponse(user, accessToken);
  }

  /**
   * @description Authenticate a user with email and password.
   * A new user session is created after successful login.
   * @returns User with access token.
   */
  async loginUser(loginUserInput: LoginUserInput): Promise<UserResponse> {
    const { accessToken, refreshToken, sessionState } = await this.keycloakApiClientService.getUserTokenUsingPassword(
      loginUserInput.email,
      loginUserInput.password
    );
    const decodedNewRefreshToken = this.decodeToken<DecodedRefreshToken>(refreshToken);
    const ttlMilliseconds = this.calculateTtlInMillis(decodedNewRefreshToken.exp);
    const hashedNewRefreshToken = this.hashToken(refreshToken);
    await this.cacheManager.set(sessionState, hashedNewRefreshToken, ttlMilliseconds);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedNewRefreshToken.sub });
    return this.buildUserResponse(user, accessToken);
  }

  /**
   * @description Get a currently authenticated user.
   * @returns Current user with access token.
   */
  async getCurrentUser(decodedAccessToken: DecodedAccessToken): Promise<UserResponse> {
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedAccessToken.sub });
    return this.buildUserResponse(user);
  }

  /**
   * @description Change an existing password with a new password.
   * All existing sessions of the user are deleted and a new session is created after successful password update.
   * @returns Current user with access token.
   */
  async changeUserPassword(
    decodedAccessToken: DecodedAccessToken,
    changeUserPasswordInput: ChangeUserPasswordInput
  ): Promise<UserResponse> {
    const passwordIsValid = await this.keycloakApiClientService.isPasswordValid(
      decodedAccessToken.email,
      changeUserPasswordInput.oldPassword
    );
    if (!passwordIsValid) {
      throw new UserInvalidPasswordError();
    }
    await this.keycloakApiClientService.changePassword(decodedAccessToken.sub, changeUserPasswordInput.newPassword);
    const userOldSessions = await this.keycloakApiClientService.getSessionsByUserId(decodedAccessToken.sub);
    await this.keycloakApiClientService.deleteSessionsByUserId(decodedAccessToken.sub);
    const userOldSessionIds = userOldSessions.map((oldSession) => oldSession.id);
    for (const oldSessionId of userOldSessionIds) {
      await this.cacheManager.del(oldSessionId);
    }
    const { accessToken, refreshToken, sessionState } = await this.keycloakApiClientService.getUserTokenUsingPassword(
      decodedAccessToken.email,
      changeUserPasswordInput.newPassword
    );
    const decodedNewRefreshToken = this.decodeToken<DecodedRefreshToken>(refreshToken);
    const ttlMilliseconds = this.calculateTtlInMillis(decodedNewRefreshToken.exp);
    const hashedNewRefreshToken = this.hashToken(refreshToken);
    await this.cacheManager.set(sessionState, hashedNewRefreshToken, ttlMilliseconds);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedAccessToken.sub });
    return this.buildUserResponse(user, accessToken);
  }

  /**
   * @description Update user information.
   * - A refresh token is used to extend the current user session and return a new access token.
   * @returns Current user with access token.
   */
  async updateUserInfo(decodedAccessToken: DecodedAccessToken, updateUserInfoInput: UpdateUserInfoInput): Promise<UserResponse> {
    const cachedRefreshToken = await this.cacheManager.get<string>(decodedAccessToken.sid);
    if (!cachedRefreshToken) {
      throw new UserRefreshTokenExpiredError();
    }
    const newTokenResponse = await this.keycloakApiClientService.getUserTokenUsingRefreshToken(cachedRefreshToken);
    const decodedNewRefreshToken = this.decodeToken<DecodedRefreshToken>(newTokenResponse.refreshToken);
    const ttlMilliseconds = this.calculateTtlInMillis(decodedNewRefreshToken.exp);
    const hashedNewRefreshToken = this.hashToken(newTokenResponse.refreshToken);
    await this.cacheManager.set(newTokenResponse.sessionState, hashedNewRefreshToken, ttlMilliseconds);
    const updateKeycloakUserInput = omitBy(pick(updateUserInfoInput, ['email', 'username']), isNil);
    await this.keycloakApiClientService.updateUserInfo(decodedAccessToken.sub, updateKeycloakUserInput);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedAccessToken.sub });
    return this.buildUserResponse(user, newTokenResponse.accessToken);
  }

  /**
   * @description Decode JWT from base64 to utf8.
   * @param token Base64-encoded token.
   * @returns Decoded token.
   */
  private decodeToken<T>(token: string): T {
    return JSON.parse(Buffer.from(token.split('.')[1], 'base64').toString());
  }

  /**
   * @description Calculate TTL from now upto the given epoch seconds.
   * @param expiryEpochSeconds Epoch seconds of expiry date time.
   * @returns TTL as milliseconds.
   */
  private calculateTtlInMillis(expiryEpochSeconds: number): number {
    const nowInEpochSeconds = DateTime.now().toSeconds();
    const ttlSeconds = expiryEpochSeconds - nowInEpochSeconds;
    const ttlMilliseconds = Math.ceil(ttlSeconds) * 1000;
    return ttlMilliseconds;
  }

  /**
   * @description Hash JWT using sha256 algorithm.
   * @returns Hashed JWT
   */
  private hashToken(token: string): string {
    const hash = createHash('sha256');
    return hash.update(token).digest('hex');
  }

  /**
   * @description Build user response using user entity and encoded access token.
   * @returns User response.
   */
  private buildUserResponse(user: User, userAccessToken?: string): UserResponse {
    const { username, email, bio } = user;
    return { username, email, bio, image: null, token: userAccessToken || null };
  }
}