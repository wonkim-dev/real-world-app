import { HttpException, Injectable, InternalServerErrorException, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { camelCase, mapKeys } from 'lodash';
import { CreateUserInput, SessionResponse, TokenResponse, UpdateUserInfoInput } from './auth.model';

enum KeycloakCredentialType {
  Password = 'password',
}

enum KeycloakGrantType {
  Password = 'password',
  ClientCredentials = 'client_credentials',
  RefreshToken = 'refresh_token',
}

@Injectable()
export class KeycloakApiClientService {
  private readonly logger = new Logger(KeycloakApiClientService.name); // Best practice - https://stackoverflow.com/a/52907695
  private readonly keycloakHost: string;
  private readonly keycloakRealm: string;
  private readonly keycloakClientId: string;
  private readonly keycloakClientSecret: string;

  constructor(private configService: ConfigService, private httpService: HttpService) {
    this.keycloakHost = this.configService.get('iam.host');
    this.keycloakRealm = this.configService.get('iam.realm');
    this.keycloakClientId = this.configService.get('iam.clientId');
    this.keycloakClientSecret = this.configService.get('iam.clientSecret');
  }

  /**
   * @description Fetch user token using password password grant type
   * @returns Access and refresh tokens
   */
  async getUserTokenUsingPassword(username: string, password: string): Promise<TokenResponse> {
    const config = { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } };
    const url = `${this.keycloakHost}/realms/${this.keycloakRealm}/protocol/openid-connect/token`;
    const body = {
      grant_type: KeycloakGrantType.Password,
      client_id: this.keycloakClientId,
      client_secret: this.keycloakClientSecret,
      username,
      password,
    };
    try {
      const { data } = await firstValueFrom(this.httpService.post(url, body, config));
      return this.camelCaseTokenResponse(data);
    } catch (error) {
      this.logger.error(error.response?.data || error.response?.statusText || error.response || error, error.stack);
      if (error.response) {
        throw new HttpException(error.response.data || error.response.statusText, error.response.status);
      }
      throw new InternalServerErrorException('Failed to fetch access token of the user');
    }
  }

  async getUserTokenUsingRefreshToken(refreshToken: string): Promise<TokenResponse> {
    const config = { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } };
    const url = `${this.keycloakHost}/realms/${this.keycloakRealm}/protocol/openid-connect/token`;
    const body = {
      grant_type: KeycloakGrantType.RefreshToken,
      client_id: this.keycloakClientId,
      client_secret: this.keycloakClientSecret,
      refresh_token: refreshToken,
    };
    try {
      const { data } = await firstValueFrom(this.httpService.post(url, body, config));
      return this.camelCaseTokenResponse(data);
    } catch (error) {
      this.logger.error(error.response?.data || error.response?.statusText || error.response || error, error.stack);
      if (error.response) {
        throw new HttpException(error.response.data || error.response.statusText, error.response.status);
      }
      throw new InternalServerErrorException('Failed to fetch access token of the user');
    }
  }

  /**
   * @description Check if password is valid for the given username
   * - This request creates a new user session in Keycloak in case of a valid password.
   * - If this is executed for administrative task, the session needs to be deleted.
   * @returns Boolean
   */
  async isPasswordValid(username: string, password: string): Promise<boolean> {
    const config = { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } };
    const url = `${this.keycloakHost}/realms/${this.keycloakRealm}/protocol/openid-connect/token`;
    const body = {
      grant_type: KeycloakGrantType.Password,
      client_id: this.keycloakClientId,
      client_secret: this.keycloakClientSecret,
      username,
      password,
    };
    try {
      await firstValueFrom(this.httpService.post(url, body, config));
      return true;
    } catch (error) {
      return false;
    }
  }

  /**
   * @description Create a new Keycloak user with credentials
   * @param createUserInput User information to create
   */
  async createKeycloakUser(createUserInput: CreateUserInput): Promise<void> {
    const serviceAccountToken = await this.getServiceAccountAccessToken();
    const config = { headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${serviceAccountToken}` } };
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/users`;
    const salt = this.createRandomSalt(12);
    const body = {
      username: createUserInput.username,
      email: createUserInput.email,
      enabled: true,
      credentials: [
        {
          type: KeycloakCredentialType.Password,
          temporary: false,
          value: createUserInput.password,
          credentialData: JSON.stringify({ hashIterations: 27500, algorithm: 'pbkdf2-sha256', additionalParameters: {} }),
          secretData: JSON.stringify({ salt: Buffer.from(salt).toString('base64') }),
        },
      ],
    };
    try {
      await firstValueFrom(this.httpService.post(url, body, config));
    } catch (error) {
      this.logger.error(error.response?.data || error.response?.statusText || error.response || error, error.stack);
      if (error.response) {
        throw new HttpException(error.response.data || error.response.statusText, error.response.status);
      }
      throw new InternalServerErrorException('Failed to create user');
    }
  }

  /**
   * @description Reset an existing password with a new one
   */
  async changePassword(userId: string, newPassword: string): Promise<void> {
    const serviceAccountToken = await this.getServiceAccountAccessToken();
    const config = { headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${serviceAccountToken}` } };
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/users/${userId}/reset-password`;
    const salt = this.createRandomSalt(12);
    const body = {
      type: KeycloakCredentialType.Password,
      temporary: false,
      value: newPassword,
      credentialData: JSON.stringify({ hashIterations: 27500, algorithm: 'pbkdf2-sha256', additionalParameters: {} }),
      secretData: JSON.stringify({ salt: Buffer.from(salt).toString('base64') }),
    };
    try {
      await firstValueFrom(this.httpService.put(url, body, config));
    } catch (error) {
      this.logger.error(error.response?.data || error.response?.statusText || error.response || error, error.stack);
      if (error.response) {
        throw new HttpException(error.response.data || error.response.statusText, error.response.status);
      }
      throw new InternalServerErrorException('Failed to change password');
    }
  }

  /**
   * @description Delete all user sessions associated with the user
   * @param userId
   */
  async deleteSessionsByUserId(userId: string): Promise<void> {
    const serviceAccountToken = await this.getServiceAccountAccessToken();
    const config = { headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${serviceAccountToken}` } };
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/users/${userId}/logout`;
    try {
      await firstValueFrom(this.httpService.post(url, null, config));
    } catch (error) {
      this.logger.error(error.response?.data || error.response?.statusText || error.response || error, error.stack);
      if (error.response) {
        throw new HttpException(error.response.data || error.response.statusText, error.response.status);
      }
      throw new InternalServerErrorException();
    }
  }

  async getSessionsByUserId(userId: string): Promise<SessionResponse[]> {
    const serviceAccountToken = await this.getServiceAccountAccessToken();
    const config = { headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${serviceAccountToken}` } };
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/users/${userId}/sessions`;
    try {
      const { data } = await firstValueFrom(this.httpService.get(url, config));
      return data;
    } catch (error) {
      this.logger.error(error.response?.data || error.response?.statusText || error.response || error, error.stack);
      if (error.response) {
        throw new HttpException(error.response.data || error.response.statusText, error.response.status);
      }
      throw new InternalServerErrorException();
    }
  }

  async deleteSessionBySessionId(sessionId: string): Promise<void> {
    const serviceAccountToken = await this.getServiceAccountAccessToken();
    const config = { headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${serviceAccountToken}` } };
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/sessions/${sessionId}`;
    try {
      await firstValueFrom(this.httpService.delete(url, config));
    } catch (error) {
      this.logger.error(error.response?.data || error.response?.statusText || error.response || error, error.stack);
      if (error.response) {
        throw new HttpException(error.response.data || error.response.statusText, error.response.status);
      }
      throw new InternalServerErrorException('Failed to delete a session');
    }
  }

  async updateUserInfo(userId: string, updateKeycloakUserInput: Partial<UpdateUserInfoInput>): Promise<void> {
    const serviceAccountToken = await this.getServiceAccountAccessToken();
    const config = { headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${serviceAccountToken}` } };
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/users/${userId}`;
    try {
      await firstValueFrom(this.httpService.put(url, updateKeycloakUserInput, config));
    } catch (error) {
      this.logger.error(error.response?.data || error.response?.statusText || error.response || error, error.stack);
      if (error.response) {
        throw new HttpException(error.response.data || error.response.statusText, error.response.status);
      }
      throw new InternalServerErrorException('Failed to create user');
    }
  }

  /**
   * @description Fetch service account access token using client credentials from Keycloak
   * @returns Service account access token
   */
  private async getServiceAccountAccessToken(): Promise<string> {
    const config = { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } };
    const url = `${this.keycloakHost}/realms/${this.keycloakRealm}/protocol/openid-connect/token`;
    const body = {
      grant_type: KeycloakGrantType.ClientCredentials,
      client_id: this.keycloakClientId,
      client_secret: this.keycloakClientSecret,
    };
    try {
      const { data } = await firstValueFrom(this.httpService.post(url, body, config));
      return data.access_token;
    } catch (error) {
      this.logger.error(error.response?.data || error.response?.statusText || error.response || error, error.stack);
      if (error.response) {
        throw new HttpException(error.response.data || error.response.statusText, error.response.status);
      }
      throw new InternalServerErrorException('Failed to fetch access token of client service account');
    }
  }

  /**
   * @description Create a random salt used to hash password
   * @param length Lenght of salt
   * @returns Randomly generated salt
   */
  private createRandomSalt(length: number): string {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()';
    const characterLength = characters.length;
    let salt = '';
    for (let i = 0; i < length; i++) {
      salt += characters.charAt(Math.floor(Math.random() * characterLength));
    }
    return salt;
  }

  private camelCaseTokenResponse(tokenObject: any): TokenResponse {
    return mapKeys(tokenObject, (value, key) => camelCase(key)) as TokenResponse;
  }
}
