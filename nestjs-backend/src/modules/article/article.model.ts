import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsArray, IsNotEmpty, IsOptional, IsString, ValidateNested } from 'class-validator';
import { Article } from '../../entities';
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

  constructor(article: Article) {
    this.slug = article.slug;
    this.title = article.title;
    this.description = article.description;
    this.body = article.body;
    this.createdAt = article.createdAt.toISOString();
    this.updatedAt = article.updatedAt.toISOString();
  }
}

export class ArticleResponse {
  @ApiProperty()
  article: ArticleData;
}

export class ArticlesResponse {
  @ApiProperty()
  articles: ArticleData[];
}
