import { Column, Entity, Index, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Article } from './Article';
import { Tag } from './Tag';

@Index('article_tag_mapping_pkey', ['articleTagMappingId'], { unique: true })
@Index('article_tag_mapping_unique_article_tag', ['fkArticleId', 'fkTagId'], {
  unique: true,
})
@Entity('article_tag_mapping', { schema: 'public' })
export class ArticleTagMapping {
  @PrimaryGeneratedColumn({ type: 'integer', name: 'article_tag_mapping_id' })
  articleTagMappingId: number;

  @Column('integer', { name: 'fk_article_id', unique: true })
  fkArticleId: number;

  @Column('integer', { name: 'fk_tag_id', unique: true })
  fkTagId: number;

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

  @ManyToOne(() => Article, (article) => article.articleTagMappings, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn([{ name: 'fk_article_id', referencedColumnName: 'articleId' }])
  fkArticle: Article;

  @ManyToOne(() => Tag, (tag) => tag.articleTagMappings, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn([{ name: 'fk_tag_id', referencedColumnName: 'tagId' }])
  fkTag: Tag;
}
