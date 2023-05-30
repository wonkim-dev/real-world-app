import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsEmail, IsNotEmpty, IsOptional, IsString, ValidateNested } from 'class-validator';

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

export class CreateUserDto {
  @ApiProperty()
  @ValidateNested()
  @Type(() => CreateUserInput)
  user: CreateUserInput;
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

export class LoginUserDto {
  @ApiProperty()
  @ValidateNested()
  @Type(() => LoginUserInput)
  user: LoginUserInput;
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

export class ChangeUserPasswordDto {
  @ApiProperty()
  @ValidateNested()
  @Type(() => ChangeUserPasswordInput)
  user: ChangeUserPasswordInput;
}

export class UpdateUserInfoInput {
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

export class UserData {
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

export class UserResponse {
  @ApiProperty()
  user: UserData;
}
