export type CreateKeycloakUserInput = {
  username: string;
  email: string;
  password: string;
};

export type UpdateKeycloakUserInput = Pick<CreateKeycloakUserInput, 'username' | 'email'>;

export type TokenResponse = {
  accessToken: string;
  expiresIn: number;
  refreshExpiresIn: number;
  refreshToken: string;
  tokenType: string;
  notBeforePolicy: number;
  sessionState: string;
  scope: string;
};

export type SessionResponse = {
  id: string;
  username: string;
  userId: string;
  ipAddress: string;
  start: number;
  lastAccess: number;
  rememberMe: boolean;
  clients: object;
};
