import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { KeycloakApiClientService } from './keycloak-api-client.service';

@Module({
  controllers: [UserController],
  providers: [UserService, KeycloakApiClientService],
})
export class AuthModule {}
