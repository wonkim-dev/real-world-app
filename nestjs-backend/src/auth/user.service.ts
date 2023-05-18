import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { KeycloakApiClientService } from './keycloak-api-client.service';
import { CreateUserInput, DecodedToken, LoginUserInput, UpdateUserInfoInput, ChangeUserPasswordInput, UserResponse } from './auth.model';
import { User } from '../entity';
import { InvalidPasswordError } from './auth.error';
import { isNil, omitBy, pick } from 'lodash';

export const refreshTokenStore = new Map<string, string>(); // TODO: refresh tokne needs to be cached

@Injectable()
export class UserService {
  constructor(private dataSource: DataSource, private keycloakApiClientService: KeycloakApiClientService) {}

  /**
   * @description Create a new Keycloak user and insert a new user entity
   * @returns Created user with access token
   */
  async createUser(createUserInput: CreateUserInput): Promise<UserResponse> {
    await this.keycloakApiClientService.createKeycloakUser(createUserInput);
    const { username, email, password } = createUserInput;
    const { accessToken, refreshToken, sessionState } = await this.keycloakApiClientService.getUserTokenUsingPassword(username, password);
    const decodedToken = this.decodeToken(accessToken);
    refreshTokenStore.set(sessionState, refreshToken);
    const user = await this.dataSource.manager.save(User, { userId: decodedToken.sub, username, email });
    return this.buildUserResponse(user, accessToken);
  }

  /**
   * @description Authenticate a user with email and password
   * @returns User with access token
   */
  async loginUser(loginUserInput: LoginUserInput): Promise<UserResponse> {
    const { accessToken, refreshToken, sessionState } = await this.keycloakApiClientService.getUserTokenUsingPassword(
      loginUserInput.email,
      loginUserInput.password
    );
    const decodedToken = this.decodeToken(accessToken);
    refreshTokenStore.set(sessionState, refreshToken);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedToken.sub });
    return this.buildUserResponse(user, accessToken);
  }

  /**
   * @description Get a currently authenticated user
   * @returns Current user with access token
   */
  async getCurrentUser(decodedToken: DecodedToken): Promise<UserResponse> {
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedToken.sub });
    return this.buildUserResponse(user);
  }

  /**
   * @description Change an existing password with a new password
   * @returns Current user with access token
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
    userOldSessionIds.forEach((oldSessionId) => refreshTokenStore.delete(oldSessionId));
    const { accessToken, refreshToken, sessionState } = await this.keycloakApiClientService.getUserTokenUsingPassword(
      decodedToken.email,
      changeUserPasswordInput.newPassword
    );
    refreshTokenStore.set(sessionState, refreshToken);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedToken.sub });
    return this.buildUserResponse(user, accessToken);
  }

  async updateUserInfo(decodedToken: DecodedToken, updateUserInfoInput: UpdateUserInfoInput): Promise<UserResponse> {
    const refreshToken = refreshTokenStore.get(decodedToken.sid); // TODO: validate refresh token expiration
    const newTokenObject = await this.keycloakApiClientService.getUserTokenUsingRefreshToken(refreshToken);
    refreshTokenStore.set(newTokenObject.sessionState, newTokenObject.refreshToken);
    const updateKeycloakUserInput = omitBy(pick(updateUserInfoInput, ['email', 'username']), isNil);
    await this.keycloakApiClientService.updateUserInfo(decodedToken.sub, updateKeycloakUserInput);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedToken.sub });
    return this.buildUserResponse(user, newTokenObject.accessToken);
  }

  /**
   * @description Decode Keycloak access token from base64 to utf8
   * @param token base64-encoded token
   * @returns Decoded token
   */
  private decodeToken(token: string): DecodedToken {
    return JSON.parse(Buffer.from(token.split('.')[1], 'base64').toString());
  }

  /**
   * @description Build user response using user entity and encoded access token
   * @returns User response
   */
  private buildUserResponse(user: User, userAccessToken?: string): UserResponse {
    const { username, email, bio } = user;
    return { username, email, bio, image: null, token: userAccessToken || null };
  }
}
