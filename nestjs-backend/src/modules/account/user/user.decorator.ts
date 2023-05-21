import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { Request } from 'express';

export const AccessToken = createParamDecorator((data: any, ctx: ExecutionContext) => {
  const request = ctx.switchToHttp().getRequest<Request>();
  const accessToken = request.headers['authorization'].split(' ')[1];
  return accessToken;
});

export const RefreshToken = createParamDecorator((data: any, ctx: ExecutionContext) => {
  const request = ctx.switchToHttp().getRequest<Request>();
  const refreshToken = request.cookies['refresh-token'];
  return refreshToken;
});
