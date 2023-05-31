import { Column, Entity, Index, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { User } from './User';

@Index('user_relation_unique_user_follower', ['fkUserId', 'followedByFkUserId'], { unique: true })
@Index('user_relation_pkey', ['userRelationId'], { unique: true })
@Entity('user_relation', { schema: 'public' })
export class UserRelation {
  @PrimaryGeneratedColumn({ type: 'integer', name: 'user_relation_id' })
  userRelationId: number;

  @Column('character varying', { name: 'fk_user_id', unique: true, length: 36 })
  fkUserId: string;

  @Column('character varying', {
    name: 'followed_by_fk_user_id',
    unique: true,
    length: 36,
  })
  followedByFkUserId: string;

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

  @ManyToOne(() => User, (user) => user.userRelationsByFkUserId, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn([{ name: 'fk_user_id', referencedColumnName: 'userId' }])
  userByFkUserId: User;

  @ManyToOne(() => User, (user) => user.userRelationsByFollowedByFkUserId, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn([{ name: 'followed_by_fk_user_id', referencedColumnName: 'userId' }])
  userByFollowedByFkUserId: User;
}
