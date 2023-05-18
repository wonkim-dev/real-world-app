import { Body, Controller, Get, Headers, Patch, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthenticatedUser, Public } from 'nest-keycloak-connect';
import { DecodedToken } from 'src/models/model';
import { UserService } from './user.service';
import { ChangeUserPasswordInput, CreateUserInput, LoginUserInput, UpdateUserInfoInput, UserResponse } from './user.model';

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
  async createUser(@Body() createUserInput: CreateUserInput): Promise<UserResponse> {
    return await this.userService.createUser(createUserInput);
  }

  @Post('login')
  @Public()
  @ApiOperation({
    summary:
      'Authenticate a user using email and password. A new user session is created after successful login. Access token for the newly created session is returned.',
  })
  @ApiResponse({ type: UserResponse, status: 201 })
  async loginUser(@Body() loginUserInput: LoginUserInput): Promise<UserResponse> {
    return await this.userService.loginUser(loginUserInput);
  }

  @Get()
  @ApiOperation({
    summary: 'Get a currently authenticated user. It does not create a new sessions, existing access token is returned instead.',
  })
  @ApiResponse({ type: UserResponse, status: 200 })
  async getCurrentUser(@AuthenticatedUser() decodedToken: DecodedToken, @Headers() headers: string): Promise<UserResponse> {
    const accessToken = headers['authorization'].split(' ')[1];
    const userResponse = await this.userService.getCurrentUser(decodedToken);
    return { ...userResponse, token: accessToken };
  }

  @Patch('password')
  @ApiOperation({
    summary:
      'Update user password. All existing sessions of the user are deleted and a new session is created after successful password update.',
  })
  @ApiResponse({ type: UserResponse, status: 200 })
  async changeUserPassword(
    @AuthenticatedUser() decodedToken: DecodedToken,
    @Body() changeUserPasswordInput: ChangeUserPasswordInput
  ): Promise<UserResponse> {
    return await this.userService.changeUserPassword(decodedToken, changeUserPasswordInput);
  }

  @Patch()
  @ApiOperation({
    summary:
      'Update user information e.g. email, username, bio, image. A refresh token stored in backend is used to extend the current user session and a new access token is returned.',
  })
  @ApiResponse({ type: UserResponse, status: 200 })
  async updateUserInfo(
    @AuthenticatedUser() decodedToken: DecodedToken,
    @Body() updateUserInfoInput: UpdateUserInfoInput
  ): Promise<UserResponse> {
    return await this.userService.updateUserInfo(decodedToken, updateUserInfoInput);
  }
}
