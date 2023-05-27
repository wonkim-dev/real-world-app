import { DateTime } from 'luxon';
import { UserService } from './user.service';
import { UserAvatarFileSizeTooBigError, UserAvatarFileTypeNotAllowedError } from './user.error';

describe('UserService', () => {
  let userService: any;
  const ENCODED_TOKEN =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
  const DECODED_TOKEN = { sub: '1234567890', name: 'John Doe', iat: 1516239022 };

  beforeEach(() => {
    userService = new UserService({ get: jest.fn() } as any, {} as any, {} as any, {} as any, {} as any, {} as any);
  });

  describe('validateAvatarImageFileSize', () => {
    it('should return true if avatar file size is valid', () => {
      // ARRANGE
      const avatar = { size: 300000 };
      // ACT
      const result = userService.validateAvatarImageFileSize(avatar, 500);
      // ASSERT
      expect(result).toBe(true);
    });

    it('should fail if avatar file size is bigger than max size', () => {
      // ARRANGE
      const avatar = { size: 6000000 };
      try {
        // ACT
        userService.validateAvatarImageFileSize(avatar, 500);
      } catch (error) {
        // ASSERT
        expect(error).toBeInstanceOf(UserAvatarFileSizeTooBigError);
      }
    });
  });

  describe('validateAvatarImageFileType', () => {
    it('should return true if avatar file type is valid', () => {
      // ARRANGE
      const avatar = { mimetype: 'image/png' };
      const allowedMimeTypesForAvatar = 'image/jpeg,image/png,image/gif';
      // ACT
      const result = userService.validateAvatarImageFileType(avatar, allowedMimeTypesForAvatar);
      // ASSERT
      expect(result).toBe(true);
    });

    it('should fail if avatar is bigger than max size', () => {
      // ARRANGE
      const avatar = { mimetype: 'image/png' };
      const allowedMimeTypesForAvatar = 'image/jpeg,image/gif';
      try {
        // ACT
        userService.validateAvatarImageFileType(avatar, allowedMimeTypesForAvatar);
      } catch (error) {
        // ASSERT
        expect(error).toBeInstanceOf(UserAvatarFileTypeNotAllowedError);
      }
    });
  });

  describe('decodeToken', () => {
    it('should decode token from base64 to utf8', () => {
      // ACT
      const decodedToken = userService.decodeToken(ENCODED_TOKEN);
      // ASSERT
      expect(decodedToken).toEqual(DECODED_TOKEN);
    });
  });

  describe('calculateTtlUsingExpiryEpochSeconds', () => {
    it('should calculate TTL in seconds and milliseconds', () => {
      // ARRANGE
      const nowInSeconds = DateTime.now().toSeconds();
      const ttl = 60;
      const expiryEpochSeconds = nowInSeconds + 60;
      // ACT
      const { ttlMilliseconds, ttlSeconds } = userService.calculateTtlUsingExpiryEpochSeconds(expiryEpochSeconds);
      // ASSERT
      expect(ttlSeconds).toBe(ttl);
      expect(ttlMilliseconds).toBe(ttl * 1000);
    });
  });

  describe('setRefreshTokenInHttpOnlyCookie', () => {
    it('should set refresh token into cookie', () => {
      // ARRANGE
      const resMock = { cookie: jest.fn() };
      const refreshToken = 'refreshToken';
      const ttlSeconds = 60;
      const path = '/api/users/refresh';
      // ACT
      userService.setRefreshTokenInHttpOnlyCookie(resMock, refreshToken, ttlSeconds);
      // ASSERT
      expect(resMock.cookie).toHaveBeenCalledWith('refresh-token', refreshToken, {
        httpOnly: true,
        maxAge: ttlSeconds,
        path,
        secure: false,
      });
    });
  });
});
