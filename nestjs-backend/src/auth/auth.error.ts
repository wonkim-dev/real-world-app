import { UnauthorizedException } from '@nestjs/common';

export class InvalidPasswordError extends UnauthorizedException {
  static message = 'Password is invalid';
  static code = 'INVALID_PASSWORD';
  constructor() {
    super(InvalidPasswordError.message, InvalidPasswordError.code);
  }
}
