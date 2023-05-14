import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString } from 'class-validator';

// ----------
// Input DTO
// ----------
export class CreateUserInput {
  @IsString()
  @ApiProperty()
  username: string;

  @IsEmail()
  @ApiProperty()
  email: string;

  @IsString()
  @ApiProperty()
  password: string;
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
