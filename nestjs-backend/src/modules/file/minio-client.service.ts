import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Client } from 'minio';
import { FileCreateBucketFailedError } from './file.error';

@Injectable()
export class MinioClientService {
  private readonly logger = new Logger(MinioClientService.name);
  private readonly bucketName = this.config.get<string>('objectStorage.bucket');

  constructor(private config: ConfigService, private minioClient: Client) {}

  /**
   * @description This lifecycle hook is executed after all modules have been initialized, but before listening for connections.
   */
  async onApplicationBootstrap(): Promise<void> {
    await this.createBucketIfNotExists();
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
