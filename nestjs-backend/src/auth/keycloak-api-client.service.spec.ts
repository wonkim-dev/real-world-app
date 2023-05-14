import { KeycloakApiClientService } from './keycloak-api-client.service';

describe('KeycloakApiClientService', () => {
  let keycloakApiClientService: any;

  beforeAll(() => {
    keycloakApiClientService = new KeycloakApiClientService({ get: jest.fn() } as any, {} as any);
  });

  describe('createRandomSalt', () => {
    it('should create a salt with 12 characters', () => {
      const salt = keycloakApiClientService.createRandomSalt(12);
      expect(salt.length).toBe(12);
      expect(typeof salt).toBe('string');
    });

    it('should return empty string if length is zero', () => {
      const salt = keycloakApiClientService.createRandomSalt(0);
      expect(salt).toBe('');
    });
  });
});
