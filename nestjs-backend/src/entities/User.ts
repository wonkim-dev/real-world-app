import { Column, Entity, Index, OneToMany } from 'typeorm';
import { Article } from './Article';
import { ArticleUserMapping } from './ArticleUserMapping';
import { Comment } from './Comment';
import { UserUserMapping } from './UserUserMapping';

@Index('user_pkey', ['userId'], { unique: true })
@Index('user_unique_username', ['username'], { unique: true })
@Entity('user', { schema: 'public' })
export class User {
  @Column('character varying', { primary: true, name: 'user_id', length: 36 })
  userId: string;

  @Column('character varying', { name: 'username', unique: true, length: 255 })
  username: string;

  @Column('character varying', { name: 'email', nullable: true, length: 255 })
  email: string | null;

  @Column('text', { name: 'bio', nullable: true })
  bio: string | null;

  @Column('character varying', { name: 'avatar_path', nullable: true, length: 255 })
  avatarPath: string | null;

  @Column('timestamp with time zone', {
    name: 'created_at',
    nullable: true,
    default: () => 'CURRENT_TIMESTAMP',
  })
  createdAt: Date | null;

  @Column('timestamp with time zone', {
    name: 'update_at',
    nullable: true,
    default: () => 'CURRENT_TIMESTAMP',
  })
  updateAt: Date | null;

  @OneToMany(() => Article, (article) => article.fkUser)
  articles: Article[];

  @OneToMany(() => ArticleUserMapping, (articleUserMapping) => articleUserMapping.favoritedByFkUser)
  articleUserMappings: ArticleUserMapping[];

  @OneToMany(() => Comment, (comment) => comment.fkUser)
  comments: Comment[];

  @OneToMany(() => UserUserMapping, (userUserMapping) => userUserMapping.fkUser)
  userUserMappings: UserUserMapping[];

  @OneToMany(() => UserUserMapping, (userUserMapping) => userUserMapping.followedByFkUser)
  userUserMappings2: UserUserMapping[];
}
