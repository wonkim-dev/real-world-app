import { Column, Entity, Index, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { ArticleTagMapping } from './ArticleTagMapping';

@Index('tag_unique_name', ['name'], { unique: true })
@Index('tag_pkey', ['tagId'], { unique: true })
@Entity('tag', { schema: 'public' })
export class Tag {
  @PrimaryGeneratedColumn({ type: 'integer', name: 'tag_id' })
  tagId: number;

  @Column('text', { name: 'name', unique: true })
  name: string;

  @Column('timestamp with time zone', {
    name: 'created_at',
    nullable: true,
    default: () => 'CURRENT_TIMESTAMP',
  })
  createdAt: Date | null;

  @Column('timestamp with time zone', {
    name: 'updated_at',
    nullable: true,
    default: () => 'CURRENT_TIMESTAMP',
  })
  updatedAt: Date | null;

  @OneToMany(() => ArticleTagMapping, (articleTagMapping) => articleTagMapping.fkTag)
  articleTagMappings: ArticleTagMapping[];
}
