import { ConfigModule } from '@nestjs/config';
import databaseConfig from '../configs/database.config';
import iamConfig from '../configs/iam.config';
import cacheConfig from '../configs/cache-store.config';

export default ConfigModule.forRoot({
  isGlobal: true,
  envFilePath: '.env',
  load: [databaseConfig, iamConfig, cacheConfig],
});
