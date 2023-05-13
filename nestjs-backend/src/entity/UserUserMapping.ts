import { Column, Entity, Index, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { User } from './User';

@Index('user_user_mapping_unique_user_follower', ['fkUserId', 'followedByFkUserId'], { unique: true })
@Index('user_user_mapping_pkey', ['userUserMappingId'], { unique: true })
@Entity('user_user_mapping', { schema: 'public' })
export class UserUserMapping {
  @PrimaryGeneratedColumn({ type: 'integer', name: 'user_user_mapping_id' })
  userUserMappingId: number;

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

  @ManyToOne(() => User, (user) => user.userUserMappings, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn([{ name: 'fk_user_id', referencedColumnName: 'userId' }])
  fkUser: User;

  @ManyToOne(() => User, (user) => user.userUserMappings2, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  @JoinColumn([{ name: 'followed_by_fk_user_id', referencedColumnName: 'userId' }])
  followedByFkUser: User;
}
