import { Controller, Get } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { Public } from 'nest-keycloak-connect';
import { TagsResponse } from './tag.model';
import { TagService } from './tag.service';

@Controller('tags')
@ApiBearerAuth()
@ApiTags('tags')
export class TagController {
  constructor(private tagService: TagService) {}

  @Get()
  @Public()
  @ApiOperation({ summary: 'Get a list of tags. Authentication is not required.' })
  @ApiResponse({ type: TagsResponse, status: 200 })
  async getTags() {
    const tags = await this.tagService.getTags();
    return { tags };
  }
}
