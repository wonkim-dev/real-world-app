import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Response } from 'express';
import { Cache } from 'cache-manager';
import { DataSource } from 'typeorm';
import { isEmpty, isNil, omitBy, pick } from 'lodash';
import { DateTime } from 'luxon';
import * as mime from 'mime-types';
import { DecodedAccessToken, DecodedRefreshToken } from '../../../models/model';
import { EncryptedData } from '../../auth/models/auth.model';
import { KeycloakApiClientService } from '../../auth/keycloak-api-client.service';
import { EncryptionService } from '../../auth/encryption.service';
import { MinioClientService } from '../../file/minio-client.service';
import { User } from '../../../entities';
import {
  UserInvalidPasswordError,
  UserInvalidRefreshTokenError,
  UserRefreshTokenExpiredError,
  UserMissingRefreshTokenError,
  UserAvatarFileTypeNotAllowedError,
  UserAvatarFileSizeTooBigError,
} from './user.error';
import {
  ChangeUserPasswordInput,
  CreateUserInput,
  LoginUserInput,
  RefreshTokenInput,
  UpdateUserInfoInput,
  UserResponse,
} from './user.model';

enum RefreshTokenHttpOnlyCookieOption {
  CookieName = 'refresh-token',
  Path = '/api/users/refresh',
}

@Injectable()
export class UserService {
  allowedMimeTypesForAvatar = this.config.get<string>('backend.fileAllowedMimeTypesForAvatar');
  maxFileSizeInKbForAvatar = this.config.get<number>('backend.fileMaxFileSizeInKbForAvatar');

  constructor(
    private config: ConfigService,
    private dataSource: DataSource,
    @Inject(CACHE_MANAGER) private cacheManager: Cache,
    private keycloakApiClientService: KeycloakApiClientService,
    private encryptionService: EncryptionService,
    private minioClientService: MinioClientService
  ) {}

  /**
   * @description Create a new user account.
   * It creates a new Keycloak user and inserts a new user entity.
   * A new user session is created after successful user registration.
   * @returns Created user with access token.
   */
  async createUser(res: Response, createUserInput: CreateUserInput): Promise<UserResponse> {
    await this.keycloakApiClientService.createKeycloakUser(createUserInput);
    const { username, email, password } = createUserInput;
    const { accessToken, refreshToken, sessionState } = await this.keycloakApiClientService.getUserTokenUsingPassword(username, password);
    const decodedNewRefreshToken = this.decodeToken<DecodedRefreshToken>(refreshToken);
    const encryptedNewRefreshToken = this.encryptionService.encrypt(refreshToken);
    const { ttlMilliseconds, ttlSeconds } = this.calculateTtlUsingExpiryEpochSeconds(decodedNewRefreshToken.exp);
    await this.cacheManager.set(sessionState, encryptedNewRefreshToken, ttlMilliseconds);
    const user = await this.dataSource.manager.save(User, { userId: decodedNewRefreshToken.sub, username, email });
    this.setRefreshTokenInHttpOnlyCookie(res, refreshToken, ttlSeconds);
    return {
      username: user.username,
      email: user.email,
      bio: user.bio,
      image: null,
      accessToken,
    };
  }

  /**
   * @description Authenticate a user with email and password.
   * A new user session is created after successful login.
   * @returns User with access token.
   */
  async loginUser(res: Response, loginUserInput: LoginUserInput): Promise<UserResponse> {
    const { accessToken, refreshToken, sessionState } = await this.keycloakApiClientService.getUserTokenUsingPassword(
      loginUserInput.email,
      loginUserInput.password
    );
    const decodedNewRefreshToken = this.decodeToken<DecodedRefreshToken>(refreshToken);
    const encryptedNewRefreshToken = this.encryptionService.encrypt(refreshToken);
    const { ttlMilliseconds, ttlSeconds } = this.calculateTtlUsingExpiryEpochSeconds(decodedNewRefreshToken.exp);
    await this.cacheManager.set(sessionState, encryptedNewRefreshToken, ttlMilliseconds);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedNewRefreshToken.sub });
    let presignedAvatarUrl: string;
    if (user.avatarPath) {
      presignedAvatarUrl = await this.minioClientService.getPresignedDownloadUrl(user.avatarPath);
    }
    this.setRefreshTokenInHttpOnlyCookie(res, refreshToken, ttlSeconds);
    return {
      username: user.username,
      email: user.email,
      bio: user.bio,
      image: presignedAvatarUrl || null,
      accessToken,
    };
  }

  /**
   * @description Get a currently authenticated user.
   * @returns Current user with access token.
   */
  async getCurrentUser(decodedAccessToken: DecodedAccessToken): Promise<UserResponse> {
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedAccessToken.sub });
    let presignedAvatarUrl: string;
    if (user.avatarPath) {
      presignedAvatarUrl = await this.minioClientService.getPresignedDownloadUrl(user.avatarPath);
    }
    return {
      username: user.username,
      email: user.email,
      bio: user.bio,
      image: presignedAvatarUrl || null,
      accessToken: null,
    };
  }

  /**
   * @description Change an existing password with a new password.
   * All existing sessions of the user are deleted and a new session is created after successful password update.
   * @returns Current user with access token.
   */
  async changeUserPassword(
    res: Response,
    decodedAccessToken: DecodedAccessToken,
    changeUserPasswordInput: ChangeUserPasswordInput
  ): Promise<UserResponse> {
    const passwordIsValid = await this.keycloakApiClientService.isPasswordValid(
      decodedAccessToken.email,
      changeUserPasswordInput.oldPassword
    );
    if (!passwordIsValid) {
      throw new UserInvalidPasswordError();
    }
    await this.keycloakApiClientService.changePassword(decodedAccessToken.sub, changeUserPasswordInput.newPassword);
    const userOldSessions = await this.keycloakApiClientService.getSessionsByUserId(decodedAccessToken.sub);
    await this.keycloakApiClientService.deleteSessionsByUserId(decodedAccessToken.sub);
    const userOldSessionIds = userOldSessions.map((oldSession) => oldSession.id);
    for (const oldSessionId of userOldSessionIds) {
      await this.cacheManager.del(oldSessionId);
    }
    const { accessToken, refreshToken, sessionState } = await this.keycloakApiClientService.getUserTokenUsingPassword(
      decodedAccessToken.email,
      changeUserPasswordInput.newPassword
    );
    const decodedNewRefreshToken = this.decodeToken<DecodedRefreshToken>(refreshToken);
    const encryptedNewRefreshToken = this.encryptionService.encrypt(refreshToken);
    const { ttlMilliseconds, ttlSeconds } = this.calculateTtlUsingExpiryEpochSeconds(decodedNewRefreshToken.exp);
    await this.cacheManager.set(sessionState, encryptedNewRefreshToken, ttlMilliseconds);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedAccessToken.sub });
    let presignedAvatarUrl: string;
    if (user.avatarPath) {
      presignedAvatarUrl = await this.minioClientService.getPresignedDownloadUrl(user.avatarPath);
    }
    this.setRefreshTokenInHttpOnlyCookie(res, refreshToken, ttlSeconds);
    return {
      username: user.username,
      email: user.email,
      bio: user.bio,
      image: presignedAvatarUrl || null,
      accessToken,
    };
  }

  /**
   * @description Update user information.
   * A refresh token is used to extend the current user session and return a new access token.
   * @returns Current user with access token.
   */
  async updateUserInfo(
    res: Response,
    decodedAccessToken: DecodedAccessToken,
    updateUserInfoInput: UpdateUserInfoInput,
    avatar: Express.Multer.File
  ): Promise<UserResponse> {
    const encryptedData = await this.cacheManager.get<EncryptedData>(decodedAccessToken.sid);
    if (!encryptedData) {
      throw new UserRefreshTokenExpiredError();
    }
    let avatarPath: string;
    if (avatar) {
      this.validateAvatarImageOrFail(avatar);
      const extension = mime.extension(avatar.mimetype);
      avatarPath = `users/${decodedAccessToken.sub}/avatar.${extension}`;
      await this.minioClientService.uploadFile(avatarPath, avatar.buffer, avatar.size);
    }
    await this.updateKeycloakUser(decodedAccessToken.sub, updateUserInfoInput);
    const user = await this.updateUser(decodedAccessToken.sub, updateUserInfoInput, avatarPath);
    const cachedRefreshToken = this.encryptionService.decrypt(encryptedData);
    const newTokenResponse = await this.keycloakApiClientService.getUserTokenUsingRefreshToken(cachedRefreshToken);
    const decodedNewRefreshToken = this.decodeToken<DecodedRefreshToken>(newTokenResponse.refreshToken);
    const encryptedNewRefreshToken = this.encryptionService.encrypt(newTokenResponse.refreshToken);
    const { ttlMilliseconds, ttlSeconds } = this.calculateTtlUsingExpiryEpochSeconds(decodedNewRefreshToken.exp);
    await this.cacheManager.set(decodedAccessToken.sid, encryptedNewRefreshToken, ttlMilliseconds);
    let presignedAvatarUrl: string;
    if (user.avatarPath) {
      presignedAvatarUrl = await this.minioClientService.getPresignedDownloadUrl(user.avatarPath);
    }
    this.setRefreshTokenInHttpOnlyCookie(res, newTokenResponse.refreshToken, ttlSeconds);
    return {
      username: user.username,
      email: user.email,
      bio: user.bio,
      image: presignedAvatarUrl || null,
      accessToken: newTokenResponse.accessToken,
    };
  }

  /**
   * @description Create a new access token using refresh token passed via http only cookies.
   * @returns User with access token
   */
  async refreshAccessToken(res: Response, refreshToken: string, refreshTokenInput: RefreshTokenInput): Promise<UserResponse> {
    if (!refreshToken) {
      throw new UserMissingRefreshTokenError();
    }
    const encryptedData = await this.cacheManager.get<EncryptedData>(refreshTokenInput.sessionId);
    if (!encryptedData) {
      throw new UserInvalidRefreshTokenError();
    }
    const cachedRefreshToken = this.encryptionService.decrypt(encryptedData);
    if (refreshToken !== cachedRefreshToken) {
      throw new UserInvalidRefreshTokenError();
    }
    const newTokenResponse = await this.keycloakApiClientService.getUserTokenUsingRefreshToken(refreshToken);
    const decodedNewRefreshToken = this.decodeToken<DecodedRefreshToken>(newTokenResponse.refreshToken);
    const encryptedNewRefreshToken = this.encryptionService.encrypt(newTokenResponse.refreshToken);
    const { ttlMilliseconds, ttlSeconds } = this.calculateTtlUsingExpiryEpochSeconds(decodedNewRefreshToken.exp);
    await this.cacheManager.set(decodedNewRefreshToken.sid, encryptedNewRefreshToken, ttlMilliseconds);
    const user = await this.dataSource.manager.findOneBy(User, { userId: decodedNewRefreshToken.sub });
    let presignedAvatarUrl: string;
    if (user.avatarPath) {
      presignedAvatarUrl = await this.minioClientService.getPresignedDownloadUrl(user.avatarPath);
    }
    this.setRefreshTokenInHttpOnlyCookie(res, newTokenResponse.refreshToken, ttlSeconds);
    return {
      username: user.username,
      email: user.email,
      bio: user.bio,
      image: presignedAvatarUrl || null,
      accessToken: newTokenResponse.accessToken,
    };
  }

  /**
   * @description Check if avatar image file is valid in type and size. If not, error is thrown.
   */
  private validateAvatarImageOrFail(avatar: Express.Multer.File): void {
    this.validateAvatarImageFileSize(avatar, this.maxFileSizeInKbForAvatar);
    this.validateAvatarImageFileType(avatar, this.allowedMimeTypesForAvatar);
  }

  private validateAvatarImageFileSize(avatar: Express.Multer.File, maxFileSizeInKbForAvatar: number): boolean {
    const avatarFileSizeInByte = avatar.size;
    const maxFileSizeInByteForAvatar = maxFileSizeInKbForAvatar * 1000;
    if (avatarFileSizeInByte > maxFileSizeInByteForAvatar) {
      throw new UserAvatarFileSizeTooBigError(this.maxFileSizeInKbForAvatar);
    }
    return true;
  }

  private validateAvatarImageFileType(avatar: Express.Multer.File, allowedMimeTypesForAvatar: string): boolean {
    const mimeTypeList = allowedMimeTypesForAvatar.split(',');
    if (!mimeTypeList.includes(avatar.mimetype)) {
      throw new UserAvatarFileTypeNotAllowedError(mimeTypeList.join(', '));
    }
    return true;
  }

  /**
   * @description Update user entity in database with the new input.
   * @returns Updated user entity.
   */
  private async updateUser(userId: string, updateUserInfoInput: UpdateUserInfoInput, avatarPath: string): Promise<User> {
    const updateUserEntityInput = omitBy(
      omitBy(pick({ ...updateUserInfoInput, avatarPath }, ['username', 'bio', 'avatarPath']), isNil),
      isEmpty
    );
    await this.dataSource.manager.update(User, { userId }, updateUserEntityInput);
    const updatedUser = await this.dataSource.manager.findOneBy(User, { userId });
    return updatedUser;
  }

  /**
   * @description Update user information in Keycloak with the new input.
   */
  private async updateKeycloakUser(userId: string, updateUserInfoInput: UpdateUserInfoInput): Promise<void> {
    const updateKeycloakUserInput = omitBy(omitBy(pick(updateUserInfoInput, ['username']), isNil), isEmpty);
    await this.keycloakApiClientService.updateUserInfo(userId, { ...updateKeycloakUserInput });
  }

  /**
   * @description Decode JWT from base64 to utf8.
   * @param token Base64-encoded token.
   * @returns Decoded token.
   */
  private decodeToken<T>(token: string): T {
    return JSON.parse(Buffer.from(token.split('.')[1], 'base64').toString());
  }

  /**
   * @description Calculate TTL from now upto the given epoch seconds.
   * @param expiryEpochSeconds Epoch seconds of expiry date time.
   * @returns TTL as milliseconds and seconds
   */
  private calculateTtlUsingExpiryEpochSeconds(expiryEpochSeconds: number): { ttlMilliseconds: number; ttlSeconds: number } {
    const nowInEpochSeconds = DateTime.now().toSeconds();
    const ttlSeconds = Math.ceil(expiryEpochSeconds - nowInEpochSeconds);
    const ttlMilliseconds = ttlSeconds * 1000;
    return { ttlMilliseconds, ttlSeconds };
  }

  /**
   * @description Attach refresh token into response as http only cookie.
   * @param res Express response object to which refresh token is attached.
   * @param refreshToken Refresh token to be attached.
   * @param ttlSeconds TTL in seconds which is set as max-age for the cookie.
   */
  private setRefreshTokenInHttpOnlyCookie(res: Response, refreshToken: string, ttlSeconds: number): void {
    res.cookie(RefreshTokenHttpOnlyCookieOption.CookieName, refreshToken, {
      httpOnly: true,
      maxAge: ttlSeconds,
      path: RefreshTokenHttpOnlyCookieOption.Path,
      secure: !isNil(process.env.NODE_ENV) && process.env.NODE_ENV === 'production',
    });
  }
}
