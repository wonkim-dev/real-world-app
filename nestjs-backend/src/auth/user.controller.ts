import { Body, Controller, Get, Headers, Patch, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthenticatedUser, Public } from 'nest-keycloak-connect';
import { CreateUserInput, DecodedToken, LoginUserInput, UpdatePasswordInput, UserResponse } from './auth.model';
import { UserService } from './user.service';

@Controller('api/users')
@ApiBearerAuth()
@ApiTags('users')
export class UserController {
  constructor(private userService: UserService) {}

  @Post()
  @Public()
  @ApiOperation({ summary: 'Create a new user' })
  async createUser(@Body() createUserInput: CreateUserInput): Promise<UserResponse> {
    return await this.userService.createUser(createUserInput);
  }

  @Post('login')
  @Public()
  @ApiOperation({ summary: 'Authenticate a user using email and password' })
  async loginUser(@Body() loginUserInput: LoginUserInput): Promise<UserResponse> {
    return await this.userService.loginUser(loginUserInput);
  }

  @Get()
  @ApiOperation({ summary: 'Get a currently authenticated user' })
  async getCurrentUser(@AuthenticatedUser() decodedToken: DecodedToken, @Headers() headers: string): Promise<UserResponse> {
    const accessToken = headers['authorization'].split(' ')[1];
    return await this.userService.getCurrentUser(decodedToken, accessToken);
  }

  @Patch('password')
  @ApiOperation({ summary: 'Update user password' })
  async changePassword(
    @AuthenticatedUser() decodedToken: DecodedToken,
    @Body() changePasswordInput: UpdatePasswordInput
  ): Promise<UserResponse> {
    return await this.userService.changePassword(decodedToken, changePasswordInput);
  }
}
