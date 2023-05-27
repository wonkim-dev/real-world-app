import { Controller, Get } from '@nestjs/common';
import { Public } from 'nest-keycloak-connect';

@Controller()
export class AppController {
  @Get('health')
  @Public()
  getHealth(): string {
    return 'OK';
  }
}
