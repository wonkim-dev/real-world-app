import { registerAs } from '@nestjs/config';
import { isEmpty, isNil, toNumber } from 'lodash';
import { ConfigRequiredEnvVarsMissingError } from './config.error';

function validateRequiredEnvVarsOrFail() {
  if (
    isNil(process.env.MINIO_ENDPOINT) ||
    isEmpty(process.env.MINIO_ENDPOINT) ||
    isNil(process.env.MINIO_ROOT_USER) ||
    isEmpty(process.env.MINIO_ROOT_USER) ||
    isNil(process.env.MINIO_ROOT_PASSWORD) ||
    isEmpty(process.env.MINIO_ROOT_PASSWORD) ||
    isNil(process.env.MINIO_BUCKET) ||
    isEmpty(process.env.MINIO_BUCKET)
  ) {
    throw new ConfigRequiredEnvVarsMissingError();
  }
}

export default registerAs('objectStorage', () => {
  validateRequiredEnvVarsOrFail();
  return {
    endPoint: process.env.MINIO_ENDPOINT, // required
    port: isNil(process.env.MINIO_PORT) || isEmpty(process.env.MINIO_PORT) ? 9000 : toNumber(process.env.MINIO_PORT),
    useSSL: isNil(process.env.MINIO_USER_SSL) || isEmpty(process.env.MINIO_USER_SSL) ? false : process.env.MINIO_USER_SSL === 'true',
    accessKey: process.env.MINIO_ROOT_USER, // required
    secretKey: process.env.MINIO_ROOT_PASSWORD, // required
    bucket: process.env.MINIO_BUCKET, // required
  };
});
