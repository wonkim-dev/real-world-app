import { Body, Controller, Get, HttpCode, Patch, Post, Res } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiOperation,
  ApiResponse,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
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
  @ApiBadRequestResponse({ description: 'Invalid input' })
  @ApiConflictResponse({ description: 'Username or email already exists' })
  async createUser(@Body() createUserInput: CreateUserInput, @Res({ passthrough: true }) res: Response): Promise<UserResponse> {
    return await this.userService.createUser(res, createUserInput);
  }

  @Post('login')
  @HttpCode(200)
  @Public()
  @ApiOperation({
    summary:
      'Authenticate a user using email and password. A new user session is created after successful login. Access token for the newly created session is returned.',
  })
  @ApiResponse({ type: UserResponse, status: 200 })
  @ApiBadRequestResponse({ description: 'Invalid input' })
  @ApiUnauthorizedResponse({ description: 'Authentication failed' })
  async loginUser(@Body() loginUserInput: LoginUserInput, @Res({ passthrough: true }) res: Response): Promise<UserResponse> {
    return await this.userService.loginUser(res, loginUserInput);
  }

  @Get()
  @ApiOperation({
    summary: 'Get a currently authenticated user. Authentication is required.',
    description: 'It does not create a new sessions, existing access token is returned instead.',
  })
  @ApiResponse({ type: UserResponse, status: 200 })
  @ApiUnauthorizedResponse({ description: 'Authentication failed' })
  async getCurrentUser(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @AccessToken() accessToken: string
  ): Promise<UserResponse> {
    const userResponse = await this.userService.getCurrentUser(decodedAccessToken);
    return { ...userResponse, accessToken };
  }

  @Patch('password')
  @ApiOperation({
    summary: 'Update user password. Authentication is required.',
    description: 'All existing sessions of the user are deleted and a new session is created after successful password update.',
  })
  @ApiResponse({ type: UserResponse, status: 200 })
  @ApiBadRequestResponse({ description: 'Invalid input' })
  @ApiUnauthorizedResponse({ description: 'Authentication failed' })
  async changeUserPassword(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Res({ passthrough: true }) res: Response,
    @Body() changeUserPasswordInput: ChangeUserPasswordInput
  ): Promise<UserResponse> {
    return await this.userService.changeUserPassword(res, decodedAccessToken, changeUserPasswordInput);
  }

  @Patch()
  @ApiOperation({
    summary: 'Update user information such as username, bio, image. Authentication is required.',
    description:
      'A refresh token stored in backend is used to extend the current user session after successful update. A newly issued access token is returned.',
  })
  @ApiResponse({ type: UserResponse, status: 200 })
  @ApiUnauthorizedResponse({ description: 'Authentication failed' })
  @ApiConflictResponse({ description: 'Username already exists' })
  async updateUserInfo(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Res({ passthrough: true }) res: Response,
    @Body() updateUserInfoInput: UpdateUserInfoInput
  ): Promise<UserResponse> {
    return await this.userService.updateUserInfo(res, decodedAccessToken, updateUserInfoInput);
  }

  @Post('refresh')
  @HttpCode(200)
  @Public()
  @ApiOperation({ summary: 'Extend a current user session by creating a new access token using refresh token.' })
  @ApiResponse({ type: UserResponse, status: 200 })
  @ApiUnauthorizedResponse({ description: 'Authentication failed' })
  async refreshAccessToken(
    @Res({ passthrough: true }) res: Response,
    @RefreshToken() refreshToken: string,
    @Body() refreshTokenInput: RefreshTokenInput
  ): Promise<UserResponse> {
    return await this.userService.refreshAccessToken(res, refreshToken, refreshTokenInput);
  }
}
