import { ConfigModule } from '@nestjs/config';
import databaseConfig from '../configs/database.config';
import iamConfig from '../configs/iam.config';

export default ConfigModule.forRoot({
  isGlobal: true,
  envFilePath: '.env',
  load: [databaseConfig, iamConfig],
});
