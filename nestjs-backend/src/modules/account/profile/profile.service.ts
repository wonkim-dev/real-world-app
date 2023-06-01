import { Injectable, InternalServerErrorException, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { PG_FOREIGN_KEY_VIOLATION, PG_UNIQUE_VIOLATION } from '@drdgvhbh/postgres-error-codes';
import { ProfileData } from './profile.model';
import { User, UserRelation } from '../../../entities';
import { ProfileAlreadyFollowingError, ProfileInvalidUserIdError, ProfileNotFoundError } from './profile.error';
import { MinioClientService } from '../../file/minio-client.service';
import { DecodedAccessToken } from '../../../models/model';

@Injectable()
export class ProfileService {
  private readonly logger = new Logger(ProfileService.name);

  constructor(private dataSource: DataSource, private minioClientService: MinioClientService) {}

  /**
   * @description Fetch a profile by username.
   * @throws {ProfileNotFoundError} Profile does not exist.
   * @throws {FileGetAvatarPresignedUrlFailedError} Failed to get a presigned download url of avatar
   */
  async getProfile(username: string, decodedAccessToken?: DecodedAccessToken): Promise<ProfileData> {
    const targetUser = await this.dataSource.manager.findOneBy(User, { username });
    if (!targetUser) {
      throw new ProfileNotFoundError();
    }
    let presignedAvatarUrl: string;
    if (targetUser.avatarPath) {
      presignedAvatarUrl = await this.minioClientService.getPresignedDownloadUrl(targetUser.avatarPath);
    }
    let isFollowing: UserRelation;
    if (decodedAccessToken) {
      isFollowing = await this.dataSource.manager.findOneBy(UserRelation, {
        fkUserId: targetUser.userId,
        followedByFkUserId: decodedAccessToken.sub,
      });
    }
    return {
      username: targetUser.username,
      bio: targetUser.bio,
      image: presignedAvatarUrl || null,
      following: isFollowing ? true : false,
    };
  }

  /**
   * @description Follow a new profile. A new user relation is created.
   * @throws {ProfileNotFoundError} Profile does not exist.
   * @throws {ProfileAlreadyFollowingError} Authenticated user already follows the requested profile.
   * @throws {ProfileInvalidUserIdError} User id is invalid.
   * @throws {FileGetAvatarPresignedUrlFailedError} Failed to get a presigned download url of avatar.
   */
  async followProfile(decodedAccessToken: DecodedAccessToken, username: string): Promise<ProfileData> {
    const targetUser = await this.dataSource.manager.findOneBy(User, { username });
    if (!targetUser) {
      throw new ProfileNotFoundError();
    }
    let presignedAvatarUrl: string;
    if (targetUser.avatarPath) {
      presignedAvatarUrl = await this.minioClientService.getPresignedDownloadUrl(targetUser.avatarPath);
    }
    const userRelationPayload = { fkUserId: targetUser.userId, followedByFkUserId: decodedAccessToken.sub };
    await this.createUserRelation(userRelationPayload);
    return {
      username: targetUser.username,
      bio: targetUser.bio,
      image: presignedAvatarUrl || null,
      following: true,
    };
  }

  /**
   * @description Unfollow a profile. An existing user relation is deleted.
   * @throws {ProfileNotFoundError} Profile does not exist.
   */
  async unfollowProfile(decodedAccessToken: DecodedAccessToken, username: string): Promise<ProfileData> {
    const targetUser = await this.dataSource.manager.findOneBy(User, { username });
    if (!targetUser) {
      throw new ProfileNotFoundError();
    }
    let presignedAvatarUrl: string;
    if (targetUser.avatarPath) {
      presignedAvatarUrl = await this.minioClientService.getPresignedDownloadUrl(targetUser.avatarPath);
    }
    await this.dataSource.manager.delete(UserRelation, { fkUserId: targetUser.userId, followedByFkUserId: decodedAccessToken.sub });
    return {
      username: targetUser.username,
      bio: targetUser.bio,
      image: presignedAvatarUrl || null,
      following: false,
    };
  }

  private async createUserRelation(userRelationPayload: Partial<UserRelation>): Promise<void> {
    try {
      await this.dataSource.manager.insert(UserRelation, userRelationPayload);
    } catch (error) {
      if (error.code === PG_UNIQUE_VIOLATION) {
        throw new ProfileAlreadyFollowingError();
      } else if (error.code === PG_FOREIGN_KEY_VIOLATION) {
        throw new ProfileInvalidUserIdError();
      }
      this.logger.error(error);
      throw new InternalServerErrorException('Failed to create a new user relation.');
    }
  }
}
