import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Client } from 'minio';
import { MinioClientService } from './minio-client.service';

@Module({
  providers: [
    {
      provide: Client,
      inject: [ConfigService],
      useFactory: (config: ConfigService) => {
        return new Client({
          endPoint: config.get<string>('objectStorage.endPoint'),
          port: config.get<number>('objectStorage.port'),
          useSSL: config.get<boolean>('objectStorage.useSSL'),
          accessKey: config.get<string>('objectStorage.accessKey'),
          secretKey: config.get<string>('objectStorage.secretKey'),
        });
      },
    },
    {
      provide: MinioClientService,
      inject: [ConfigService, Client],
      useFactory(config: ConfigService, client: Client) {
        return new MinioClientService(config, client);
      },
    },
  ],
  exports: [MinioClientService],
})
export class FileModule {}
