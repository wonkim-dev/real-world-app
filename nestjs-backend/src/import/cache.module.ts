import { CacheModule } from '@nestjs/cache-manager';
import { ConfigService } from '@nestjs/config';
import { redisStore } from 'cache-manager-redis-yet';
import { toNumber } from 'lodash';

export default CacheModule.registerAsync({
  isGlobal: true,
  inject: [ConfigService],
  useFactory: async (configService: ConfigService) => {
    return {
      store: await redisStore({
        ttl: toNumber(configService.get('cacheStore.defaultTtl')),
        password: configService.get('cacheStore.password'),
        url: configService.get('cacheStore.url'),
      }),
    };
  },
});
