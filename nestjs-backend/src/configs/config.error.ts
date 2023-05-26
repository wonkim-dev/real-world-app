import { InternalServerErrorException } from '@nestjs/common';

export class ConfigRequiredEnvVarsMissingError extends InternalServerErrorException {
  static code = 'required_env_vars_missing';
  static message = 'Required environment variables are not provided.';
  constructor() {
    super(ConfigRequiredEnvVarsMissingError.message, ConfigRequiredEnvVarsMissingError.code);
  }
}
