import { Controller, Delete, Get, Param, Post } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiConflictResponse,
  ApiInternalServerErrorResponse,
  ApiNotFoundResponse,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AuthenticatedUser, Public } from 'nest-keycloak-connect';
import { ProfileService } from './profile.service';
import { ProfileResponse } from './profile.model';
import { DecodedAccessToken } from '../../../models/model';
import { DecodedAccessTokenOptional } from './profile.decorator';

@Controller('api/profiles')
@ApiBearerAuth()
@ApiTags('profiles')
export class ProfileController {
  constructor(private profileService: ProfileService) {}

  @Get(':username')
  @Public()
  @ApiOperation({
    summary: 'Get a profile of a user by username. Authentication is not required.',
    description: 'If authenticated, whether the authenticated user follows the requested user is checked and returned in the response.',
  })
  @ApiResponse({ type: ProfileResponse })
  @ApiNotFoundResponse({ description: 'Profile not found' })
  async getProfile(
    @DecodedAccessTokenOptional() decodedAccessToken: DecodedAccessToken,
    @Param('username') username: string
  ): Promise<ProfileResponse> {
    const profile = await this.profileService.getProfile(username, decodedAccessToken);
    return { profile };
  }

  @Post(':username/follow')
  @ApiOperation({ summary: 'Follow the requested profile. Authentication is required.' })
  @ApiResponse({ type: ProfileResponse })
  @ApiConflictResponse({ description: 'Authenticated user already follows the profile.' })
  @ApiInternalServerErrorResponse({ description: 'Invalid user id' })
  async followProfile(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Param('username') username: string
  ): Promise<ProfileResponse> {
    const profile = await this.profileService.followProfile(decodedAccessToken, username);
    return { profile };
  }

  @Delete(':username/unfollow')
  @ApiOperation({ summary: 'Unfollow the requested profile. Authentication is required.' })
  @ApiResponse({ type: ProfileResponse })
  async unfollowProfile(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Param('username') username: string
  ): Promise<ProfileResponse> {
    const profile = await this.profileService.unfollowProfile(decodedAccessToken, username);
    return { profile };
  }
}
