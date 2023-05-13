import { Column, Entity, Index, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { User } from './User';
import { ArticleTagMapping } from './ArticleTagMapping';
import { ArticleUserMapping } from './ArticleUserMapping';
import { Comment } from './Comment';

@Index('article_pkey', ['articleId'], { unique: true })
@Index('article_unique_slug', ['slug'], { unique: true })
@Entity('article', { schema: 'public' })
export class Article {
  @PrimaryGeneratedColumn({ type: 'integer', name: 'article_id' })
  articleId: number;

  @Column('text', { name: 'slug', unique: true })
  slug: string;

  @Column('text', { name: 'title' })
  title: string;

  @Column('text', { name: 'description', nullable: true })
  description: string | null;

  @Column('text', { name: 'body' })
  body: string;

  @Column('character varying', { name: 'fk_user_id', length: 36 })
  fkUserId: string;

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

  @ManyToOne(() => User, (user) => user.articles, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn([{ name: 'fk_user_id', referencedColumnName: 'userId' }])
  fkUser: User;

  @OneToMany(() => ArticleTagMapping, (articleTagMapping) => articleTagMapping.fkArticle)
  articleTagMappings: ArticleTagMapping[];

  @OneToMany(() => ArticleUserMapping, (articleUserMapping) => articleUserMapping.fkArticle)
  articleUserMappings: ArticleUserMapping[];

  @OneToMany(() => Comment, (comment) => comment.fkArticle)
  comments: Comment[];
}
