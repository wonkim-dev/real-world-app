import { ConflictException, InternalServerErrorException, NotFoundException } from '@nestjs/common';

export class ProfileNotFoundError extends NotFoundException {
  static code = 'profile_not_found';
  static message = 'Profile does not exist.';
  constructor() {
    super(ProfileNotFoundError.message, ProfileNotFoundError.code);
  }
}

export class ProfileAlreadyFollowingError extends ConflictException {
  static code = 'already_following';
  static message = 'Authenticated user already follows the requested profile.';
  constructor() {
    super(ProfileAlreadyFollowingError.message, ProfileAlreadyFollowingError.code);
  }
}

export class ProfileInvalidUserIdError extends InternalServerErrorException {
  static code = 'invalid_user_id';
  static message = 'User id is invalid.';
  constructor() {
    super(ProfileInvalidUserIdError.message, ProfileInvalidUserIdError.code);
  }
}
