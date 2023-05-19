import { UnauthorizedException } from '@nestjs/common';

export class UserInvalidPasswordError extends UnauthorizedException {
  static code = 'invalid_password';
  static message = 'Incorrect password. Please try again.';
  constructor() {
    super(UserInvalidPasswordError.message, UserInvalidPasswordError.code);
  }
}

export class UserRefreshTokenExpiredError extends UnauthorizedException {
  static code = 'refresh_token_expired';
  static message = 'Your session has expired. Please log in again to continue.';
  constructor() {
    super(UserRefreshTokenExpiredError.message, UserRefreshTokenExpiredError.code);
  }
}
