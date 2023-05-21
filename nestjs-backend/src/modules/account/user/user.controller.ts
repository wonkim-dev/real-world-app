import { Body, Controller, Get, Patch, Post, Res } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { AuthenticatedUser, Public } from 'nest-keycloak-connect';
import { DecodedAccessToken } from 'src/models/model';
import { UserService } from './user.service';
import { AccessToken, RefreshToken } from './user.decorator';
import {
  ChangeUserPasswordInput,
  CreateUserInput,
  LoginUserInput,
  RefreshTokenInput,
  UpdateUserInfoInput,
  UserResponse,
} from './user.model';

@Controller('api/users')
@ApiBearerAuth()
@ApiTags('users')
export class UserController {
  constructor(private userService: UserService) {}

  @Post()
  @Public()
  @ApiOperation({
    summary:
      'Create a new user. It creates a new Keycloak user and inserts a new user entity. A new user session is created after successful user registration.',
  })
  @ApiResponse({ type: UserResponse, status: 201 })
  async createUser(@Body() createUserInput: CreateUserInput, @Res({ passthrough: true }) res: Response): Promise<UserResponse> {
    return await this.userService.createUser(res, createUserInput);
  }

  @Post('login')
  @Public()
  @ApiOperation({
    summary:
      'Authenticate a user using email and password. A new user session is created after successful login. Access token for the newly created session is returned.',
  })
  @ApiResponse({ type: UserResponse, status: 201 })
  async loginUser(@Body() loginUserInput: LoginUserInput, @Res({ passthrough: true }) res: Response): Promise<UserResponse> {
    return await this.userService.loginUser(res, loginUserInput);
  }

  @Get()
  @ApiOperation({
    summary: 'Get a currently authenticated user. It does not create a new sessions, existing access token is returned instead.',
  })
  @ApiResponse({ type: UserResponse, status: 200 })
  async getCurrentUser(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @AccessToken() accessToken: string
  ): Promise<UserResponse> {
    const userResponse = await this.userService.getCurrentUser(decodedAccessToken);
    return { ...userResponse, accessToken };
  }

  @Patch('password')
  @ApiOperation({
    summary:
      'Update user password. All existing sessions of the user are deleted and a new session is created after successful password update.',
  })
  @ApiResponse({ type: UserResponse, status: 200 })
  async changeUserPassword(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Res({ passthrough: true }) res: Response,
    @Body() changeUserPasswordInput: ChangeUserPasswordInput
  ): Promise<UserResponse> {
    return await this.userService.changeUserPassword(res, decodedAccessToken, changeUserPasswordInput);
  }

  @Patch()
  @ApiOperation({
    summary:
      'Update user information e.g. email, username, bio, image. A refresh token stored in backend is used to extend the current user session and a new access token is returned.',
  })
  @ApiResponse({ type: UserResponse, status: 200 })
  async updateUserInfo(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Res({ passthrough: true }) res: Response,
    @Body() updateUserInfoInput: UpdateUserInfoInput
  ): Promise<UserResponse> {
    return await this.userService.updateUserInfo(res, decodedAccessToken, updateUserInfoInput);
  }

  @Post('refresh')
  @Public()
  @ApiOperation({ summary: 'Extend a current user session by creating a new access token using refresh token.' })
  @ApiResponse({ type: UserResponse, status: 201 })
  async refreshAccessToken(
    @Res({ passthrough: true }) res: Response,
    @RefreshToken() refreshToken: string,
    @Body() refreshTokenInput: RefreshTokenInput
  ): Promise<UserResponse> {
    return await this.userService.refreshAccessToken(res, refreshToken, refreshTokenInput);
  }
}
