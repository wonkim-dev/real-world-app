import { InternalServerErrorException } from '@nestjs/common';

export class FileCreateBucketFailedError extends InternalServerErrorException {
  static message = 'Failed to create a bucket in MinIO server';
  static code = 'create_bucket_failed';
  constructor() {
    super(FileCreateBucketFailedError.message, FileCreateBucketFailedError.code);
  }
}

export class FileUploadFileFailedError extends InternalServerErrorException {
  static message = 'Failed to upload a file in MinIO server';
  static code = 'file_upload_failed';
  constructor() {
    super(FileUploadFileFailedError.message, FileUploadFileFailedError.code);
  }
}

export class FileGetAvatarPresignedUrlFailedError extends InternalServerErrorException {
  static message = 'Failed to get a presigned download url of avatar';
  static code = 'get_avatar_download_url_failed';
  constructor() {
    super(FileGetAvatarPresignedUrlFailedError.message, FileGetAvatarPresignedUrlFailedError.code);
  }
}
