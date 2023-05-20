import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { KeycloakApiClientService } from './keycloak-api-client.service';
import { EncryptionService } from './encryption.service';

@Module({
  imports: [HttpModule],
  providers: [KeycloakApiClientService, EncryptionService],
  exports: [KeycloakApiClientService, EncryptionService],
})
export class AuthModule {}
