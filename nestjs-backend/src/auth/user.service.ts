import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { KeycloakApiClientService } from './keycloak-api-client.service';
import { CreateUserInput, DecodedToken, LoginUserInput, UserResponse } from './auth.model';
import { User } from '../entity';

@Injectable()
export class UserService {
  constructor(private dataSource: DataSource, private keycloakApiClientService: KeycloakApiClientService) {}

  /**
   * @description Create a new Keycloak user and insert a new user entity
   * @returns Created user with access token
   */
  async createUser(createUserInput: CreateUserInput): Promise<UserResponse> {
    const serviceAccountAccessToken = await this.keycloakApiClientService.getServiceAccountAccessToken();
    await this.keycloakApiClientService.createKeycloakUser(serviceAccountAccessToken, createUserInput);
    const { username, email, password } = createUserInput;
    const userAccessToken = await this.keycloakApiClientService.getUserAccessToken(username, password);
    const decodedUserToken = this.decodeToken(userAccessToken);
    const user = await this.dataSource.manager.save(User, { userId: decodedUserToken.sub, username, email });
    return this.buildUserResponse(user, userAccessToken);
  }

  /**
   * @description Authenticate a user with email and password
   * @returns User with access token
   */
  async loginUser(loginUserInput: LoginUserInput): Promise<UserResponse> {
    const userAccessToken = await this.keycloakApiClientService.getUserAccessToken(loginUserInput.email, loginUserInput.password);
    const decodedUserToken = this.decodeToken(userAccessToken);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedUserToken.sub });
    return this.buildUserResponse(user, userAccessToken);
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
