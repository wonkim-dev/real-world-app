import { Body, Controller, Get, Param, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthenticatedUser, Public } from 'nest-keycloak-connect';
import { DecodedAccessToken } from '../../models/model';
import { ArticleService } from './article.service';
import { ArticleResponse, ArticlesResponse, CreateArticleDto, UpdateArticleDto } from './article.model';
import { ParseArticleLimitIntPipe, ParseArticleOffsetIntPipe } from './article.pipe';

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

  @Get(':slug')
  @Public()
  @ApiOperation({ summary: 'Fetch a article. Authentication is not required.' })
  @ApiResponse({ type: ArticleResponse, status: 200 })
  async getArticle(@Param('slug') slug: string): Promise<ArticleResponse> {
    const article = await this.articleService.getArticle(slug);
    return { article };
  }

  @Get('list')
  @Public()
  @ApiOperation({ summary: 'Fetch most recent articles. The results are ordered by most recent first. Authentication is not required.' })
  @ApiQuery({ name: 'tag', type: String, required: false })
  @ApiQuery({ name: 'author', type: String, required: false })
  @ApiQuery({ name: 'favoritedBy', type: String, required: false })
  @ApiQuery({ name: 'limit', type: Number, required: false })
  @ApiQuery({ name: 'offset', type: Number, required: false })
  @ApiResponse({ type: ArticlesResponse, status: 200 })
  async getArticles(
    @Query('tag') tag: string,
    @Query('author') author: string,
    @Query('favoritedBy') favoritedBy: string,
    @Query('limit', ParseArticleLimitIntPipe) limit: number,
    @Query('offset', ParseArticleOffsetIntPipe) offset: number
  ): Promise<ArticlesResponse> {
    const articleDataList = await this.articleService.getArticleList(tag, author, favoritedBy, limit, offset);
    return { articles: articleDataList };
  }

  @Get('feed')
  @ApiOperation({
    summary:
      'Fetch most recent articles created by followed users. The results are ordered by most recent first. Authentication is required.',
  })
  @ApiQuery({ name: 'limit', type: Number, required: false })
  @ApiQuery({ name: 'offset', type: Number, required: false })
  @ApiResponse({ type: ArticlesResponse, status: 200 })
  async getArticleFeed(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Query('limit', ParseArticleLimitIntPipe) limit: number,
    @Query('offset', ParseArticleOffsetIntPipe) offset: number
  ): Promise<ArticlesResponse> {
    const articleDataList = await this.articleService.getArticleFeed(decodedAccessToken, limit, offset);
    return { articles: articleDataList };
  }

  @Patch(':slug')
  @ApiOperation({ summary: 'Update an existing article' })
  @ApiResponse({ type: ArticleResponse, status: 200 })
  async updateArticle(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Body() updateArticleDto: UpdateArticleDto,
    @Param('slug') slug: string
  ): Promise<ArticleResponse> {
    const articleData = await this.articleService.updateArticle(decodedAccessToken, slug, updateArticleDto.article);
    return { article: articleData };
  }
}
