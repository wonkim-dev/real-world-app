import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsArray, IsNotEmpty, IsOptional, IsString, ValidateNested } from 'class-validator';
import { ProfileData } from '../account/profile/profile.model';

export class CreateArticleInput {
  @IsString()
  @IsNotEmpty()
  @ApiProperty()
  title: string;

  @IsString()
  @IsNotEmpty()
  @ApiProperty()
  description: string;

  @IsString()
  @IsNotEmpty()
  @ApiProperty()
  body: string;

  @IsArray()
  @IsOptional()
  @ApiProperty()
  tagList: string[];
}

export class CreateArticleDto {
  @ApiProperty()
  @ValidateNested()
  @Type(() => CreateArticleInput)
  article: CreateArticleInput;
}

export class UpdateArticleInput {
  @IsString()
  @IsOptional()
  @ApiProperty()
  title: string;

  @IsString()
  @IsOptional()
  @ApiProperty()
  description: string;

  @IsString()
  @IsOptional()
  @ApiProperty()
  body: string;
}

export class UpdateArticleDto {
  @ApiProperty()
  @ValidateNested()
  @Type(() => UpdateArticleInput)
  article: UpdateArticleInput;
}

export class CreateCommentInput {
  @IsString()
  @ApiProperty()
  body: string;
}

export class CreateCommentDto {
  @ApiProperty()
  @ValidateNested()
  @Type(() => CreateCommentInput)
  comment: CreateCommentInput;
}

export class GetArticlesListQuery {
  @ApiProperty({ type: String, required: false })
  tag: string;
  @ApiProperty({ type: String, required: false })
  author: string;
  @ApiProperty({ type: String, required: false })
  favorited: string;
  @ApiProperty({ type: Number, required: false })
  limit: number;
  @ApiProperty({ type: Number, required: false })
  offset: number;
}

export class ArticleData {
  @ApiProperty({ example: 'how-to-train-your-dragon' })
  slug: string;
  @ApiProperty({ example: 'How to train your dragon' })
  title: string;
  @ApiProperty({ example: 'Ever wonder how?' })
  description: string;
  @ApiProperty({ example: 'It takes a Jacobian' })
  body: string;
  @ApiProperty({ example: false })
  favorited: boolean;
  @ApiProperty({ example: 0 })
  favoritesCount: number;
  @ApiProperty({ example: ['dragons', 'training'] })
  tagList: string[];
  @ApiProperty({ example: '2023-06-18T03:22:56.637Z' })
  createdAt: string;
  @ApiProperty({ example: '2023-06-18T03:35:32.223Z' })
  updatedAt: string;
  @ApiProperty({ example: ProfileData })
  author: ProfileData;
}

export class ArticleResponse {
  @ApiProperty()
  article: ArticleData;
}

export class ArticlesResponse {
  @ApiProperty({ type: [ArticleData] })
  articles: ArticleData[];
}

export class CommentData {
  @ApiProperty({ example: 1 })
  id: number;
  @ApiProperty({ example: 'It takes a Jacobian' })
  body: string;
  @ApiProperty({ example: '2023-06-18T03:22:56.637Z' })
  createdAt: string;
  @ApiProperty({ example: '2023-06-18T03:35:32.223Z' })
  updatedAt: string;
  @ApiProperty({ example: ProfileData })
  author: ProfileData;
}

export class CommentResponse {
  @ApiProperty()
  comment: CommentData;
}

export class CommentsResponse {
  @ApiProperty()
  comments: CommentData[];
}
