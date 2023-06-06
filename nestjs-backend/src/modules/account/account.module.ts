import { Module } from '@nestjs/common';
import { AuthModule } from '../../modules/auth/auth.module';
import { FileModule } from '../file/file.module';
import { UserController } from './user/user.controller';
import { UserService } from './user/user.service';
import { ProfileController } from './profile/profile.controller';
import { ProfileService } from './profile/profile.service';

@Module({
  imports: [AuthModule, FileModule],
  controllers: [UserController, ProfileController],
  providers: [UserService, ProfileService],
  exports: [ProfileService],
})
export class AccountModule {}
