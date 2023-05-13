import { Column, Entity, Index, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { User } from './User';
import { Article } from './Article';

@Index('article_user_mapping_pkey', ['articleUserMappingId'], { unique: true })
@Index('article_user_mapping_unique_article_user', ['favoritedByFkUserId', 'fkArticleId'], { unique: true })
@Entity('article_user_mapping', { schema: 'public' })
export class ArticleUserMapping {
  @PrimaryGeneratedColumn({ type: 'integer', name: 'article_user_mapping_id' })
  articleUserMappingId: number;

  @Column('integer', { name: 'fk_article_id', unique: true })
  fkArticleId: number;

  @Column('character varying', {
    name: 'favorited_by_fk_user_id',
    unique: true,
    length: 36,
  })
  favoritedByFkUserId: string;

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

  @ManyToOne(() => User, (user) => user.articleUserMappings, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn([{ name: 'favorited_by_fk_user_id', referencedColumnName: 'userId' }])
  favoritedByFkUser: User;

  @ManyToOne(() => Article, (article) => article.articleUserMappings, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn([{ name: 'fk_article_id', referencedColumnName: 'articleId' }])
  fkArticle: Article;
}
