import { UserService } from './user.service';

describe('UserService', () => {
  let userService: any;
  const ENCODED_TOKEN =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
  const DECODED_TOKEN = { sub: '1234567890', name: 'John Doe', iat: 1516239022 };

  beforeAll(() => {
    userService = new UserService({} as any, {} as any);
  });

  describe('decodeToken', () => {
    it('should decode token from base64 to utf8', () => {
      // ACT
      const decodedToken = userService.decodeToken(ENCODED_TOKEN);
      // ASSERT
      expect(decodedToken).toEqual(DECODED_TOKEN);
    });
  });

  describe('buildUserResponse', () => {
    it('should build user response using user entity and access token', () => {
      // ARRANGE
      const user = { username: 'test-user', email: 'test-user@email.com', bio: 'I am a test user.' };
      // ACT
      const userResponse = userService.buildUserResponse(user, ENCODED_TOKEN);
      // ASSERT
      expect(userResponse).toEqual({ username: user.username, email: user.email, bio: user.bio, image: null, token: ENCODED_TOKEN });
    });
  });
});
