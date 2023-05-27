import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Client, ItemBucketMetadata } from 'minio';
import { FileCreateBucketFailedError, FileGetAvatarPresignedUrlFailedError, FileUploadFileFailedError } from './file.error';

@Injectable()
export class MinioClientService {
  private readonly logger = new Logger(MinioClientService.name);
  private readonly bucketName = this.config.get<string>('backend.fileBucket');
  private readonly avatarDownloadUrlTtl = this.config.get<number>('backend.fileAvatarDownloadUrlTtl');

  constructor(private config: ConfigService, private minioClient: Client) {}

  /**
   * @description This lifecycle hook is executed after all modules have been initialized, but before listening for connections.
   */
  async onApplicationBootstrap(): Promise<void> {
    await this.createBucketIfNotExists();
  }

  async uploadFile(objectName: string, buffer: Buffer, size: number, metadata?: ItemBucketMetadata) {
    try {
      await this.minioClient.putObject(this.bucketName, objectName, buffer, size, metadata);
    } catch (error) {
      this.logger.error(error);
      throw new FileUploadFileFailedError();
    }
  }

  async getPresignedDownloadUrl(objectName: string): Promise<string> {
    try {
      return await this.minioClient.presignedGetObject(this.bucketName, objectName, this.avatarDownloadUrlTtl);
    } catch (error) {
      this.logger.error(error);
      throw new FileGetAvatarPresignedUrlFailedError();
    }
  }

  /**
   * @description Initialize a bucket. This creates a bucket if it does not exist in MinIO Server.
   */
  private async createBucketIfNotExists(): Promise<void> {
    try {
      const bucketExists = await this.minioClient.bucketExists(this.bucketName);
      if (bucketExists) {
        this.logger.log(`Bucket ${this.bucketName} already exists. Skipped creating the bucket.`);
      } else {
        await this.minioClient.makeBucket(this.bucketName);
        this.logger.log(`Bucket ${this.bucketName} was created successfully.`);
      }
    } catch (error) {
      this.logger.error(error);
      throw new FileCreateBucketFailedError();
    }
  }
}
