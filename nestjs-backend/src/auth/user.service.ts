import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { KeycloakApiClientService } from './keycloak-api-client.service';
import { CreateUserInput, DecodedToken, UserResponse } from './auth.model';
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
    return {
      username: user.username,
      email: user.email,
      bio: user.bio,
      image: null,
      token: userAccessToken,
    };
  }

  /**
   * @description Decode Keycloak access token from base64 to utf8
   * @param token base64-encoded token
   * @returns Decoded token
   */
  private decodeToken(token: string): DecodedToken {
    return JSON.parse(Buffer.from(token.split('.')[1], 'base64').toString());
  }
}
