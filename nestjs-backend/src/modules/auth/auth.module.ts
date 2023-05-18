import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { KeycloakApiClientService } from './keycloak-api-client.service';

@Module({
  imports: [HttpModule],
  providers: [KeycloakApiClientService],
  exports: [KeycloakApiClientService],
})
export class AuthModule {}
