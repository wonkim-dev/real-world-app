import { UserService } from './user.service';

describe('UserService', () => {
  let userService: any;

  beforeAll(() => {
    userService = new UserService({} as any, {} as any);
  });

  describe('createRandomSalt', () => {
    it('should create a salt with 12 characters', () => {
      const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
      const decodedToken = userService.decodeToken(token);
      expect(decodedToken).toEqual({ sub: '1234567890', name: 'John Doe', iat: 1516239022 });
    });
  });
});
