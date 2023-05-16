import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { KeycloakApiClientService } from './keycloak-api-client.service';
import { CreateUserInput, DecodedToken, LoginUserInput, UpdatePasswordInput, UserResponse } from './auth.model';
import { User } from '../entity';
import { InvalidPasswordError } from './auth.error';

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
    const userAccessToken = await this.keycloakApiClientService.getUserAccessToken(username, password);
    const decodedToken = this.decodeToken(userAccessToken);
    const user = await this.dataSource.manager.save(User, { userId: decodedToken.sub, username, email });
    return this.buildUserResponse(user, userAccessToken);
  }

  /**
   * @description Authenticate a user with email and password
   * @returns User with access token
   */
  async loginUser(loginUserInput: LoginUserInput): Promise<UserResponse> {
    const userAccessToken = await this.keycloakApiClientService.getUserAccessToken(loginUserInput.email, loginUserInput.password);
    const decodedToken = this.decodeToken(userAccessToken);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedToken.sub });
    return this.buildUserResponse(user, userAccessToken);
  }

  /**
   * @description Get a currently authenticated user
   * @returns Current user with access token
   */
  async getCurrentUser(decodedToken: DecodedToken, accessToken: string): Promise<UserResponse> {
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedToken.sub });
    return this.buildUserResponse(user, accessToken);
  }

  /**
   * @description Change an existing password with a new password
   * @returns Current user with access token
   */
  async changePassword(decodedToken: DecodedToken, changePasswordInput: UpdatePasswordInput): Promise<UserResponse> {
    const passwordIsValid = await this.keycloakApiClientService.isPasswordValid(decodedToken.email, changePasswordInput.oldPassword);
    if (!passwordIsValid) {
      throw new InvalidPasswordError();
    }
    await this.keycloakApiClientService.deleteAllUserSessions(decodedToken.sub);
    await this.keycloakApiClientService.changePassword(decodedToken.sub, changePasswordInput.newPassword);
    const newUserAccessToken = await this.keycloakApiClientService.getUserAccessToken(decodedToken.email, changePasswordInput.newPassword);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedToken.sub });
    return this.buildUserResponse(user, newUserAccessToken);
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
  private buildUserResponse(user: User, userAccessToken: string): UserResponse {
    const { username, email, bio } = user;
    return { username, email, bio, image: null, token: userAccessToken };
  }
}
