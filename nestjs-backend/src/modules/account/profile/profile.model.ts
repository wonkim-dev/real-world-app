import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { ValidateNested } from 'class-validator';

export class ProfileData {
  @ApiProperty({ example: 'jake' })
  username: string;
  @ApiProperty({ example: 'I am the first user of the app!' })
  bio: string;
  @ApiProperty({ example: 'https://api.realworld.io/images/smiley-cyrus.jpg' })
  image: string;
  @ApiProperty({ example: 'true' })
  following: boolean;
}

export class ProfileResponse {
  @ApiProperty()
  @ValidateNested()
  @Type(() => ProfileData)
  profile: ProfileData;
}
