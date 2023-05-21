import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsOptional, IsString } from 'class-validator';

// ----------
// Input DTO
// ----------
export class CreateUserInput {
  @IsEmail()
  @IsNotEmpty()
  @ApiProperty()
  email: string;

  @IsString()
  @IsNotEmpty()
  @ApiProperty()
  username: string;

  @IsString()
  @IsNotEmpty()
  @ApiProperty()
  password: string;
}

export class LoginUserInput {
  @IsEmail()
  @IsNotEmpty()
  @ApiProperty()
  email: string;

  @IsString()
  @IsNotEmpty()
  @ApiProperty()
  password: string;
}

export class ChangeUserPasswordInput {
  @IsString()
  @IsNotEmpty()
  @ApiProperty()
  oldPassword: string;

  @IsString()
  @IsNotEmpty()
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

export class RefreshTokenInput {
  @IsString()
  @ApiProperty()
  sessionId: string;
}

export class UserResponse {
  @ApiProperty({ example: 'jake' })
  username: string;
  @ApiProperty({ example: 'jake@email.com' })
  email: string;
  @ApiProperty({ example: 'I am the first user of the app!' })
  bio: string;
  @ApiProperty({ example: 'https://api.realworld.io/images/smiley-cyrus.jpg' })
  image: string;
  @ApiProperty({ example: 'jwt.token.here' })
  accessToken: string;
}
