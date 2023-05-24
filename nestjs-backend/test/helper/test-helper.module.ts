import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { KeycloakApiClientHelperService } from './keycloak-api-client-helper.service';

@Module({
  imports: [HttpModule],
  providers: [KeycloakApiClientHelperService],
})
export class TestHelperModule {}
