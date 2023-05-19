import { Inject, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { isNil, omitBy, pick } from 'lodash';
import { DecodedToken } from 'src/models/model';
import { KeycloakApiClientService } from '../../auth/keycloak-api-client.service';
import { User } from '../../../entities';
import { InvalidPasswordError } from './user.error';
import { ChangeUserPasswordInput, CreateUserInput, LoginUserInput, UpdateUserInfoInput, UserResponse } from './user.model';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Cache } from 'cache-manager';

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
    const decodedToken = this.decodeToken(accessToken);
    await this.cacheManager.set(sessionState, refreshToken);
    const user = await this.dataSource.manager.save(User, { userId: decodedToken.sub, username, email });
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
    const decodedToken = this.decodeToken(accessToken);
    await this.cacheManager.set(sessionState, refreshToken);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedToken.sub });
    return this.buildUserResponse(user, accessToken);
  }

  /**
   * @description Get a currently authenticated user.
   * @returns Current user with access token.
   */
  async getCurrentUser(decodedToken: DecodedToken): Promise<UserResponse> {
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedToken.sub });
    return this.buildUserResponse(user);
  }

  /**
   * @description Change an existing password with a new password.
   * All existing sessions of the user are deleted and a new session is created after successful password update.
   * @returns Current user with access token.
   */
  async changeUserPassword(decodedToken: DecodedToken, changeUserPasswordInput: ChangeUserPasswordInput): Promise<UserResponse> {
    const passwordIsValid = await this.keycloakApiClientService.isPasswordValid(decodedToken.email, changeUserPasswordInput.oldPassword);
    if (!passwordIsValid) {
      throw new InvalidPasswordError();
    }
    await this.keycloakApiClientService.changePassword(decodedToken.sub, changeUserPasswordInput.newPassword);
    const userOldSessions = await this.keycloakApiClientService.getSessionsByUserId(decodedToken.sub);
    await this.keycloakApiClientService.deleteSessionsByUserId(decodedToken.sub);
    const userOldSessionIds = userOldSessions.map((oldSession) => oldSession.id);
    for (const oldSessionId of userOldSessionIds) {
      await this.cacheManager.del(oldSessionId);
    }
    const { accessToken, refreshToken, sessionState } = await this.keycloakApiClientService.getUserTokenUsingPassword(
      decodedToken.email,
      changeUserPasswordInput.newPassword
    );
    await this.cacheManager.set(sessionState, refreshToken);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedToken.sub });
    return this.buildUserResponse(user, accessToken);
  }

  /**
   * @description Update user information.
   * - A refresh token is used to extend the current user session and return a new access token.
   * @returns Current user with access token.
   */
  async updateUserInfo(decodedToken: DecodedToken, updateUserInfoInput: UpdateUserInfoInput): Promise<UserResponse> {
    const refreshToken = await this.cacheManager.get<string>(decodedToken.sid);
    const newTokenObject = await this.keycloakApiClientService.getUserTokenUsingRefreshToken(refreshToken);
    await this.cacheManager.set(newTokenObject.sessionState, newTokenObject.refreshToken);
    const updateKeycloakUserInput = omitBy(pick(updateUserInfoInput, ['email', 'username']), isNil);
    await this.keycloakApiClientService.updateUserInfo(decodedToken.sub, updateKeycloakUserInput);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedToken.sub });
    return this.buildUserResponse(user, newTokenObject.accessToken);
  }

  /**
   * @description Decode JWT from base64 to utf8.
   * @param token Base64-encoded token.
   * @returns Decoded token.
   */
  private decodeToken(token: string): DecodedToken {
    return JSON.parse(Buffer.from(token.split('.')[1], 'base64').toString());
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
