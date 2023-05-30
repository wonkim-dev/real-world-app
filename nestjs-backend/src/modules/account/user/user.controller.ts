import { Body, Controller, Get, HttpCode, Patch, Post, Res, UploadedFile, UseInterceptors } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiBody,
  ApiConflictResponse,
  ApiConsumes,
  ApiOperation,
  ApiResponse,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { Response } from 'express';
import { AuthenticatedUser, Public } from 'nest-keycloak-connect';
import { DecodedAccessToken } from 'src/models/model';
import { UserService } from './user.service';
import { AccessToken, RefreshToken } from './user.decorator';
import { ChangeUserPasswordDto, CreateUserDto, LoginUserDto, RefreshTokenInput, UpdateUserInfoInput, UserResponse } from './user.model';

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
  async createUser(@Body() createUserDto: CreateUserDto, @Res({ passthrough: true }) res: Response): Promise<UserResponse> {
    const user = await this.userService.createUser(res, createUserDto.user);
    return { user };
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
  async loginUser(@Body() loginUserDto: LoginUserDto, @Res({ passthrough: true }) res: Response): Promise<UserResponse> {
    const user = await this.userService.loginUser(res, loginUserDto.user);
    return { user };
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
    return { user: { ...userResponse, accessToken } };
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
    @Body() changeUserPasswordDto: ChangeUserPasswordDto
  ): Promise<UserResponse> {
    const user = await this.userService.changeUserPassword(res, decodedAccessToken, changeUserPasswordDto.user);
    return { user };
  }

  @Patch()
  @ApiConsumes('multipart/form-data')
  @ApiOperation({
    summary: 'Update user information such as username, bio, avatar image. Authentication is required.',
    description:
      'A refresh token stored in backend is used to extend the current user session after successful update. A newly issued access token is returned.',
  })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        username: { type: 'string', nullable: true },
        bio: { type: 'string', nullable: true },
        avatar: { type: 'string', format: 'binary' },
      },
    },
  })
  @ApiResponse({ type: UserResponse, status: 200 })
  @ApiUnauthorizedResponse({ description: 'Authentication failed' })
  @ApiConflictResponse({ description: 'Username already exists' })
  @UseInterceptors(FileInterceptor('avatar'))
  async updateUserInfo(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Res({ passthrough: true }) res: Response,
    @Body() updateUserInfoDto: UpdateUserInfoInput,
    @UploadedFile('file')
    avatar?: Express.Multer.File
  ): Promise<UserResponse> {
    const user = await this.userService.updateUserInfo(res, decodedAccessToken, updateUserInfoDto, avatar);
    return { user };
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
    const user = await this.userService.refreshAccessToken(res, refreshToken, refreshTokenInput);
    return { user };
  }
}
