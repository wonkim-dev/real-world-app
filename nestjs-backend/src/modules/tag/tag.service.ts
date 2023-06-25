import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Tag } from '../../entities';

@Injectable()
export class TagService {
  constructor(private dataSource: DataSource) {}

  async getTags(): Promise<string[]> {
    const tags = await this.dataSource.manager.find(Tag);
    return tags.map((tag) => tag.name);
  }
}
