import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsOptional, IsString } from 'class-validator';

// ----------
// Input DTO
// ----------
export class LoginUserInput {
  @IsEmail()
  @ApiProperty()
  email: string;

  @IsString()
  @ApiProperty()
  password: string;
}

export class CreateUserInput extends LoginUserInput {
  @IsString()
  @ApiProperty()
  username: string;
}

export class ChangeUserPasswordInput {
  @IsString()
  @ApiProperty()
  oldPassword: string;

  @IsString()
  @ApiProperty()
  newPassword: string;
}

export class UpdateUserInfoInput {
  @IsEmail()
  @IsOptional()
  @ApiProperty()
  email: string;

  @IsString()
  @IsOptional()
  @ApiProperty()
  username: string;

  @IsString()
  @IsOptional()
  @ApiProperty()
  bio: string;
}

// --------------
// Response Type
// --------------
export type UserResponse = {
  username: string;
  email: string;
  bio: string;
  image: string;
  token: string;
};

// ----------
// Data Type
// ----------
export type DecodedToken = {
  exp: number;
  iat: number;
  jti: string;
  iss: string;
  aud: string;
  sub: string;
  typ: string;
  azp: string;
  session_state: string;
  acr: string;
  'allowed-origins': string[];
  realm_access: { roles: string[] };
  resource_access: { account: { roles: string[] } };
  scope: string;
  sid: string;
  email_verified: boolean;
  preferred_username: string;
  email: string;
};

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
