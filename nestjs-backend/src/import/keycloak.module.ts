import { APP_GUARD } from '@nestjs/core';
import { ConfigService } from '@nestjs/config';
import { AuthGuard, KeycloakConnectModule, ResourceGuard, RoleGuard } from 'nest-keycloak-connect';

// eslint-disable-next-line @typescript-eslint/naming-convention
export const KeycloakModule = KeycloakConnectModule.registerAsync({
  inject: [ConfigService],
  useFactory: (configService: ConfigService) => ({
    authServerUrl: configService.get<string>('iam.host'),
    realm: configService.get<string>('iam.realm'),
    clientId: configService.get<string>('iam.clientId'),
    secret: configService.get<string>('iam.clientSecret'),
  }),
});

export const KEYCLOAK_PROVIDERS = [
  { provide: APP_GUARD, useClass: AuthGuard },
  { provide: APP_GUARD, useClass: ResourceGuard },
  { provide: APP_GUARD, useClass: RoleGuard },
];
