import { DateTime } from 'luxon';
import { UserService } from './user.service';

describe('UserService', () => {
  let userService: any;
  const ENCODED_TOKEN =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
  const DECODED_TOKEN = { sub: '1234567890', name: 'John Doe', iat: 1516239022 };

  beforeEach(() => {
    userService = new UserService({} as any, {} as any, {} as any, {} as any);
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

  describe('buildUserResponse', () => {
    it('should build user response using user entity and access token', () => {
      // ARRANGE
      const user = { username: 'test-user', email: 'test-user@email.com', bio: 'I am a test user.' };
      // ACT
      const userResponse = userService.buildUserResponse(user, ENCODED_TOKEN);
      // ASSERT
      expect(userResponse).toEqual({ username: user.username, email: user.email, bio: user.bio, image: null, accessToken: ENCODED_TOKEN });
    });
  });
});
