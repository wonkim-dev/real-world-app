import { Body, Controller, Post } from '@nestjs/common';
import { ApiOperation } from '@nestjs/swagger';
import { CreateUserInput, UserResponse } from './auth.model';
import { UserService } from './user.service';

@Controller('api/users')
export class UserController {
  constructor(private userService: UserService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new user' })
  async createUser(@Body() createUserInput: CreateUserInput): Promise<UserResponse> {
    return await this.userService.createUser(createUserInput);
  }
}
