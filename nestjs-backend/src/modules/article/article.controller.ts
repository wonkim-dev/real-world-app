import { Body, Controller, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthenticatedUser } from 'nest-keycloak-connect';
import { DecodedAccessToken } from '../../models/model';
import { ArticleService } from './article.service';
import { ArticleResponse, CreateArticleDto } from './article.model';

@Controller('articles')
@ApiBearerAuth()
@ApiTags('article')
export class ArticleController {
  constructor(private articleService: ArticleService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new article. Authentication is required.' })
  @ApiResponse({ type: ArticleResponse, status: 201 })
  async createArticle(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Body() createArticleDto: CreateArticleDto
  ): Promise<ArticleResponse> {
    const article = await this.articleService.createArticle(decodedAccessToken, createArticleDto.article);
    return { article };
  }
}
