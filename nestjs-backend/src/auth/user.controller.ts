import { Body, Controller, Post } from '@nestjs/common';
import { ApiOperation } from '@nestjs/swagger';
import { CreateUserInput, LoginUserInput, UserResponse } from './auth.model';
import { UserService } from './user.service';

@Controller('api/users')
export class UserController {
  constructor(private userService: UserService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new user' })
  async createUser(@Body() createUserInput: CreateUserInput): Promise<UserResponse> {
    return await this.userService.createUser(createUserInput);
  }

  @Post('login')
  @ApiOperation({ summary: 'Authenticate a user using email and password' })
  async loginUser(@Body() loginUserInput: LoginUserInput): Promise<UserResponse> {
    return await this.userService.loginUser(loginUserInput);
  }
}
