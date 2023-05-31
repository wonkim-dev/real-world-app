import { ExecutionContext, createParamDecorator } from '@nestjs/common';

// eslint-disable-next-line @typescript-eslint/naming-convention
export const DecodedAccessTokenOptional = createParamDecorator((data: any, ctx: ExecutionContext) => {
  const request = ctx.switchToHttp().getRequest<Request>();
  if (!request.headers['authorization']) {
    return null;
  } else {
    const accessToken = request.headers['authorization'].split(' ')[1];
    return JSON.parse(Buffer.from(accessToken.split('.')[1], 'base64').toString());
  }
});
