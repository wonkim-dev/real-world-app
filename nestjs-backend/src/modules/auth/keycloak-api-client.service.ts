import { HttpException, Injectable, InternalServerErrorException, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HttpService } from '@nestjs/axios';
import { AxiosRequestConfig } from 'axios';
import { firstValueFrom } from 'rxjs';
import { camelCase, mapKeys } from 'lodash';
import { UpdateUserInfoInput } from 'src/modules/account/user/user.model';
import { CreateKeycloakUserInput, SessionResponse, TokenResponse } from './models/auth.model';

enum KeycloakCredentialType {
  Password = 'password',
}

enum KeycloakGrantType {
  Password = 'password',
  ClientCredentials = 'client_credentials',
  RefreshToken = 'refresh_token',
}

const userCredentialData = { hashIterations: 27500, algorithm: 'pbkdf2-sha256', additionalParameters: {} };

@Injectable()
export class KeycloakApiClientService {
  private readonly logger = new Logger(KeycloakApiClientService.name);
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
   * @description Fetch user token using password grant type.
   * This request creates a new user session in Keycloak.
   * @returns Token response including access token, refresh token and session id.
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
      this.logAndThrowKeycloakApiError(error);
    }
  }

  /**
   * @description Fetch user token using refresh token grant type.
   * This request extends existing session in Keycloak.
   * @returns Token response including access token, refresh token and session id.
   */
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
      this.logAndThrowKeycloakApiError(error);
    }
  }

  /**
   * @description Check if password is valid for the given username.
   * This request creates a new user session in Keycloak if the given password is valid.
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
   * @description Create a new Keycloak user with the given credentials.
   */
  async createKeycloakUser(createUserInput: CreateKeycloakUserInput): Promise<void> {
    const config = await this.getAxiosRequestConfigForServiceAccount();
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
          credentialData: JSON.stringify(userCredentialData),
          secretData: JSON.stringify({ salt: Buffer.from(salt).toString('base64') }),
        },
      ],
    };
    try {
      await firstValueFrom(this.httpService.post(url, body, config));
    } catch (error) {
      this.logAndThrowKeycloakApiError(error);
    }
  }

  /**
   * @description Reset an existing password with a new one.
   */
  async changePassword(userId: string, newPassword: string): Promise<void> {
    const config = await this.getAxiosRequestConfigForServiceAccount();
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/users/${userId}/reset-password`;
    const salt = this.createRandomSalt(12);
    const body = {
      type: KeycloakCredentialType.Password,
      temporary: false,
      value: newPassword,
      credentialData: JSON.stringify(userCredentialData),
      secretData: JSON.stringify({ salt: Buffer.from(salt).toString('base64') }),
    };
    try {
      await firstValueFrom(this.httpService.put(url, body, config));
    } catch (error) {
      this.logAndThrowKeycloakApiError(error);
    }
  }

  /**
   * @description Update information of an existing user.
   */
  async updateUserInfo(userId: string, updateKeycloakUserInput: Partial<UpdateUserInfoInput>): Promise<void> {
    const config = await this.getAxiosRequestConfigForServiceAccount();
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/users/${userId}`;
    try {
      await firstValueFrom(this.httpService.put(url, updateKeycloakUserInput, config));
    } catch (error) {
      this.logAndThrowKeycloakApiError(error);
    }
  }

  /**
   * @description Get all sessions associated with the user.
   */
  async getSessionsByUserId(userId: string): Promise<SessionResponse[]> {
    const config = await this.getAxiosRequestConfigForServiceAccount();
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/users/${userId}/sessions`;
    try {
      const { data } = await firstValueFrom(this.httpService.get(url, config));
      return data;
    } catch (error) {
      this.logAndThrowKeycloakApiError(error);
    }
  }

  /**
   * @description Delete all sessions associated with the user.
   */
  async deleteSessionsByUserId(userId: string): Promise<void> {
    const config = await this.getAxiosRequestConfigForServiceAccount();
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/users/${userId}/logout`;
    try {
      await firstValueFrom(this.httpService.post(url, null, config));
    } catch (error) {
      this.logAndThrowKeycloakApiError(error);
    }
  }

  /**
   * @description Delete a specific session by its id.
   */
  async deleteSessionBySessionId(sessionId: string): Promise<void> {
    const config = await this.getAxiosRequestConfigForServiceAccount();
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/sessions/${sessionId}`;
    try {
      await firstValueFrom(this.httpService.delete(url, config));
    } catch (error) {
      this.logAndThrowKeycloakApiError(error);
    }
  }

  /**
   * @description Build axios request configuration for service account.
   */
  private async getAxiosRequestConfigForServiceAccount(): Promise<AxiosRequestConfig> {
    const serviceAccountToken = await this.getServiceAccountAccessToken();
    return { headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${serviceAccountToken}` } };
  }

  /**
   * @description Fetch service account access token using client credentials from.
   * @returns Service account access token.
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
      this.logAndThrowKeycloakApiError(error);
    }
  }

  /**
   * @description Catch error thrown from Keycloak admin API and throw it with proper message.
   */
  private logAndThrowKeycloakApiError(error: any): Promise<void> {
    this.logger.error(error.response?.data || error.response?.statusText || error.response || error, error.stack);
    if (error.response) {
      throw new HttpException(error.response.data || error.response.statusText, error.response.status);
    }
    throw new InternalServerErrorException();
  }

  /**
   * @description Create a random salt used to hash password.
   * @param length Length of salt.
   * @returns Randomly generated salt.
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

  /**
   * @description Convert keys in object into camel case.
   */
  private camelCaseTokenResponse(tokenObject: any): TokenResponse {
    return mapKeys(tokenObject, (value, key) => camelCase(key)) as TokenResponse;
  }
}
