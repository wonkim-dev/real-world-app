import { Column, Entity, Index, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Article } from './Article';
import { User } from './User';

@Index('comment_pkey', ['commentId'], { unique: true })
@Entity('comment', { schema: 'public' })
export class Comment {
  @PrimaryGeneratedColumn({ type: 'integer', name: 'comment_id' })
  commentId: number;

  @Column('text', { name: 'body' })
  body: string;

  @Column({ type: 'integer', name: 'fk_article_id' })
  fkArticleId: number;

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

  @ManyToOne(() => Article, (article) => article.commentsByFkArticleId, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn([{ name: 'fk_article_id', referencedColumnName: 'articleId' }])
  articleByFkArticleId: Article;

  @ManyToOne(() => User, (user) => user.commentsByFkUserId, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn([{ name: 'fk_user_id', referencedColumnName: 'userId' }])
  userByFkUserId: User;
}
