import { BadRequestException, UnauthorizedException } from '@nestjs/common';

export class UserInvalidPasswordError extends UnauthorizedException {
  static code = 'invalid_password';
  static message = 'Incorrect password. Please try again.';
  constructor() {
    super(UserInvalidPasswordError.message, UserInvalidPasswordError.code);
  }
}

export class UserAvatarFileTypeNotAllowedError extends BadRequestException {
  static code = 'avatar_file_type_not_allowed';
  constructor(mimeTypeList: string) {
    const message = 'Invalid avatar image type. Only following mime types are allowed for avatar images: ' + mimeTypeList;
    super(message, UserAvatarFileTypeNotAllowedError.code);
  }
}

export class UserAvatarFileSizeTooBigError extends BadRequestException {
  static code = 'avatar_file_size_too_big';
  constructor(maxFileSizeInKb: number) {
    const message = `Avatar image file is too big. Please reduce the file size and try gain. Maximum file size is ${maxFileSizeInKb} KB.`;
    super(message, UserAvatarFileSizeTooBigError.code);
  }
}

export class UserMissingRefreshTokenError extends UnauthorizedException {
  static code = 'missing_refresh_token';
  static message = 'Refresh token is missing in the request. Please log in again to continue';
  constructor() {
    super(UserMissingRefreshTokenError.message, UserMissingRefreshTokenError.code);
  }
}

export class UserRefreshTokenExpiredError extends UnauthorizedException {
  static code = 'refresh_token_expired';
  static message = 'Your session has expired. Please log in again to continue.';
  constructor() {
    super(UserRefreshTokenExpiredError.message, UserRefreshTokenExpiredError.code);
  }
}

export class UserInvalidRefreshTokenError extends UnauthorizedException {
  static code = 'invalid_refresh_token';
  static message = 'Refresh token is invalid. Please log in again to continue.';
  constructor() {
    super(UserInvalidRefreshTokenError.message, UserInvalidRefreshTokenError.code);
  }
}
