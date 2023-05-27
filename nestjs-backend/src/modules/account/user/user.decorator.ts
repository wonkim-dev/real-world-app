import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { Request } from 'express';

// eslint-disable-next-line @typescript-eslint/naming-convention
export const AccessToken = createParamDecorator((data: any, ctx: ExecutionContext) => {
  const request = ctx.switchToHttp().getRequest<Request>();
  const accessToken = request.headers['authorization'].split(' ')[1];
  return accessToken;
});

// eslint-disable-next-line @typescript-eslint/naming-convention
export const RefreshToken = createParamDecorator((data: any, ctx: ExecutionContext) => {
  const request = ctx.switchToHttp().getRequest<Request>();
  const refreshToken = request.cookies['refresh-token'];
  return refreshToken;
});
