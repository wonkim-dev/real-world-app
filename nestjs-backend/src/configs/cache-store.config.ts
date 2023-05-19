import { registerAs } from '@nestjs/config';

export default registerAs('cacheStore', () => ({
  defaultTtl: process.env.REDIS_DEFAULT_TTL,
  url: process.env.REDIS_URL,
  password: process.env.REDIS_PASSWORD,
}));
