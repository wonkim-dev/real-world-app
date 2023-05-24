import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AxiosRequestConfig } from 'axios';
import { firstValueFrom } from 'rxjs';

enum KeycloakGrantType {
  Password = 'password',
  ClientCredentials = 'client_credentials',
  RefreshToken = 'refresh_token',
}

@Injectable()
export class KeycloakApiClientHelperService {
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

  async deleteKeycloakUser(userId: string): Promise<void> {
    const config = await this.getAxiosRequestConfigForServiceAccount();
    const url = `${this.keycloakHost}/admin/realms/${this.keycloakRealm}/users/${userId}`;
    await firstValueFrom(this.httpService.delete(url, config));
  }

  private async getAxiosRequestConfigForServiceAccount(): Promise<AxiosRequestConfig> {
    const config = { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } };
    const url = `${this.keycloakHost}/realms/${this.keycloakRealm}/protocol/openid-connect/token`;
    const body = {
      grant_type: KeycloakGrantType.ClientCredentials,
      client_id: this.keycloakClientId,
      client_secret: this.keycloakClientSecret,
    };
    const { data } = await firstValueFrom(this.httpService.post(url, body, config));
    return { headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${data.access_token}` } };
  }
}
