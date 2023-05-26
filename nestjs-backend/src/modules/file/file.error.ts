import { InternalServerErrorException } from '@nestjs/common';

export class FileCreateBucketFailedError extends InternalServerErrorException {
  static message = 'Failed to create a bucket in MinIO server';
  static code = 'create_bucket_failed';
  constructor() {
    super(FileCreateBucketFailedError.message, FileCreateBucketFailedError.code);
  }
}
