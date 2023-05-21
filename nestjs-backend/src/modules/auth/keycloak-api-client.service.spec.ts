import { HttpException, InternalServerErrorException } from '@nestjs/common';
import { KeycloakApiClientService } from './keycloak-api-client.service';

describe('KeycloakApiClientService', () => {
  let keycloakApiClientService: any;

  beforeEach(() => {
    keycloakApiClientService = new KeycloakApiClientService({ get: jest.fn() } as any, {} as any);
  });

  describe('logAndThrowKeycloakApiError', () => {
    it('should log and throw HttpException with response message', () => {
      // ARRANGE
      const errorInput = { response: { data: 'error data', status: 401 } };
      try {
        // ACT
        keycloakApiClientService.logAndThrowKeycloakApiError(errorInput);
      } catch (error) {
        // ASSERT
        expect(error).toBeInstanceOf(HttpException);
        expect(error.response).toBe(errorInput.response.data);
        expect(error.status).toBe(errorInput.response.status);
      }
    });

    it('should log and throw InternalServerException', () => {
      // ARRANGE
      const errorInput = {};
      try {
        // ACT
        keycloakApiClientService.logAndThrowKeycloakApiError(errorInput);
      } catch (error) {
        // ASSERT
        expect(error).toBeInstanceOf(InternalServerErrorException);
        expect(error.status).toBe(500);
      }
    });
  });

  describe('createRandomSalt', () => {
    it('should create a salt with 12 characters', () => {
      // ACT
      const salt = keycloakApiClientService.createRandomSalt(12);
      // ASSERT
      expect(salt.length).toBe(12);
      expect(typeof salt).toBe('string');
    });

    it('should return empty string if length is zero', () => {
      // ACT
      const salt = keycloakApiClientService.createRandomSalt(0);
      // ASSERT
      expect(salt).toBe('');
    });
  });

  describe('camelCaseTokenResponse', () => {
    it('should camel case keys in the object', () => {
      // ARRANGE
      const obj = {
        firstKey: 'firstKey',
        'second-key': 'second-key',
        'Third-Key': 'Third-Key',
        fourth_key: 'fourth_key',
        Fifth_Key: 'Fifth_Key',
      };
      // ACT
      const result = keycloakApiClientService.camelCaseTokenResponse(obj);
      // ASSERT
      expect(result).toEqual({
        firstKey: 'firstKey',
        secondKey: 'second-key',
        thirdKey: 'Third-Key',
        fourthKey: 'fourth_key',
        fifthKey: 'Fifth_Key',
      });
    });
  });
});
