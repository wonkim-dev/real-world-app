import { registerAs } from '@nestjs/config';
import { isEmpty, isNil, toNumber } from 'lodash';
import { ConfigRequiredEnvVarsMissingError } from './config.error';

function validateEncryptionRequiredEnvVarsOrFail() {
  if (
    isNil(process.env.ENCRYPTION_ALGORITHM) ||
    isEmpty(process.env.ENCRYPTION_ALGORITHM) ||
    isNil(process.env.ENCRYPTION_CIPHER_KEY_HEX) ||
    isEmpty(process.env.ENCRYPTION_CIPHER_KEY_HEX) ||
    isNil(process.env.ENCRYPTION_CIPHER_IV_BYTES) ||
    isEmpty(process.env.ENCRYPTION_CIPHER_IV_BYTES) ||
    isNil(process.env.ENCRYPTION_AUTH_TAG_LENGTH) ||
    isEmpty(process.env.ENCRYPTION_AUTH_TAG_LENGTH)
  ) {
    throw new ConfigRequiredEnvVarsMissingError();
  }
}

function validateFileRequiredEnvVarsOrFail() {
  if (isNil(process.env.FILE_BUCKET) || isEmpty(process.env.FILE_BUCKET)) {
    throw new ConfigRequiredEnvVarsMissingError();
  }
}

export default registerAs('backend', () => {
  validateEncryptionRequiredEnvVarsOrFail();
  validateFileRequiredEnvVarsOrFail();
  return {
    encryptionAlgorithm: process.env.ENCRYPTION_ALGORITHM, // required
    encryptionCipherKeyHex: process.env.ENCRYPTION_CIPHER_KEY_HEX, // required
    encryptionCipherIvBytes: process.env.ENCRYPTION_CIPHER_IV_BYTES, // required
    encryptionAuthTagLength: process.env.ENCRYPTION_AUTH_TAG_LENGTH, // required
    fileBucket: process.env.FILE_BUCKET,
    fileAllowedMimeTypesForAvatar:
      isNil(process.env.FILE_ALLOWED_FILE_MIME_TYPES_FOR_AVATAR) || isEmpty(process.env.FILE_ALLOWED_FILE_MIME_TYPES_FOR_AVATAR)
        ? 'image/jpeg,image/png'
        : process.env.FILE_ALLOWED_FILE_MIME_TYPES_FOR_AVATAR,
    fileMaxFileSizeInKbForAvatar:
      isNil(process.env.FILE_MAX_FILE_SIZE_IN_KB_FOR_AVATAR) || isEmpty(process.env.FILE_MAX_FILE_SIZE_IN_KB_FOR_AVATAR)
        ? 512
        : toNumber(process.env.FILE_MAX_FILE_SIZE_IN_KB_FOR_AVATAR),
    fileAvatarDownloadUrlTtl:
      isNil(process.env.FILE_AVATAR_DOWNLOAD_URL_TTL) || isEmpty(process.env.FILE_AVATAR_DOWNLOAD_URL_TTL)
        ? 604800
        : toNumber(process.env.FILE_AVATAR_DOWNLOAD_URL_TTL),
  };
});
