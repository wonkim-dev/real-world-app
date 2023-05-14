import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { KeycloakApiClientService } from './keycloak-api-client.service';

@Module({
  imports: [HttpModule],
  controllers: [UserController],
  providers: [UserService, KeycloakApiClientService],
})
export class AuthModule {}
