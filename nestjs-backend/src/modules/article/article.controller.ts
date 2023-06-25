import { Body, Controller, Delete, Get, Param, Patch, Post, Query } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOperation,
  ApiQuery,
  ApiResponse,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { AuthenticatedUser, Public } from 'nest-keycloak-connect';
import { DecodedAccessToken } from '../../models/model';
import { ArticleService } from './services/article.service';
import { ArticleCommentService } from './services/article-comment.service';
import { ArticleFavoriteService } from './services/article-favorite.service';
import { ParseArticleLimitIntPipe, ParseArticleOffsetIntPipe } from './article.pipe';
import { DecodedAccessTokenOptional } from './article.decorator';
import {
  ArticleResponse,
  ArticlesResponse,
  CommentResponse,
  CommentsResponse,
  CreateArticleDto,
  CreateCommentDto,
  UpdateArticleDto,
} from './article.model';

@Controller('articles')
@ApiBearerAuth()
@ApiTags('article')
export class ArticleController {
  constructor(
    private articleService: ArticleService,
    private articleCommentService: ArticleCommentService,
    private articleFavoriteService: ArticleFavoriteService
  ) {}

  @Post()
  @ApiOperation({ summary: 'Create a new article. Authentication is required.' })
  @ApiResponse({ type: ArticleResponse, status: 201 })
  @ApiBadRequestResponse({ description: 'Required fields are not provided' })
  @ApiUnauthorizedResponse({ description: 'Authentication failed' })
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
  @ApiNotFoundResponse({ description: 'Article does not exist' })
  async getArticle(@Param('slug') slug: string): Promise<ArticleResponse> {
    const article = await this.articleService.getArticle(slug);
    return { article };
  }

  @Patch(':slug')
  @ApiOperation({ summary: 'Update an existing article. Authentication is required.' })
  @ApiResponse({ type: ArticleResponse, status: 200 })
  @ApiBadRequestResponse({ description: 'Article input is not provided' })
  @ApiUnauthorizedResponse({ description: 'Authentication failed' })
  @ApiForbiddenResponse({ description: 'Authorization failed' })
  @ApiNotFoundResponse({ description: 'Article does not exist' })
  async updateArticle(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Body() updateArticleDto: UpdateArticleDto,
    @Param('slug') slug: string
  ): Promise<ArticleResponse> {
    const articleData = await this.articleService.updateArticle(decodedAccessToken, slug, updateArticleDto.article);
    return { article: articleData };
  }

  @Delete(':slug')
  @ApiOperation({ summary: 'Delete an existing article. Authentication is required.' })
  @ApiResponse({ status: 200 })
  @ApiUnauthorizedResponse({ description: 'Authentication failed' })
  @ApiForbiddenResponse({ description: 'Authorization failed' })
  @ApiNotFoundResponse({ description: 'Article does not exist' })
  async deleteArticle(@AuthenticatedUser() decodedAccessToken: DecodedAccessToken, @Param('slug') slug: string) {
    await this.articleService.deleteArticle(decodedAccessToken, slug);
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

  @Post(':slug/comments')
  @ApiOperation({ summary: 'Create a comment to the article. Authentication is required.' })
  @ApiResponse({ type: CommentResponse, status: 201 })
  async createComment(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Param('slug') slug: string,
    @Body() createCommentDto: CreateCommentDto
  ): Promise<CommentResponse> {
    const comment = await this.articleCommentService.createComment(decodedAccessToken, slug, createCommentDto.comment);
    return { comment };
  }

  @Public()
  @Get(':slug/comments')
  @ApiOperation({ summary: 'Get comments from the article. Authentication is optional.' })
  @ApiResponse({ type: CommentsResponse, status: 200 })
  async getComments(
    @DecodedAccessTokenOptional() decodedAccessToken: DecodedAccessToken,
    @Param('slug') slug: string
  ): Promise<CommentsResponse> {
    const comments = await this.articleCommentService.getComments(decodedAccessToken, slug);
    return { comments };
  }

  @Post(':slug/favorite')
  @ApiOperation({ summary: 'Favorite an article. Authentication is required.' })
  @ApiResponse({ type: ArticleResponse, status: 201 })
  async favoriteArticle(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Param('slug') slug: string
  ): Promise<ArticleResponse> {
    const article = await this.articleFavoriteService.favoriteArticle(decodedAccessToken, slug);
    return { article };
  }

  @Delete(':slug/favorite')
  @ApiOperation({ summary: 'Unfavorite an article. Authentication is required.' })
  @ApiResponse({ type: ArticleResponse, status: 200 })
  async unfavoriteArticle(
    @AuthenticatedUser() decodedAccessToken: DecodedAccessToken,
    @Param('slug') slug: string
  ): Promise<ArticleResponse> {
    const article = await this.articleFavoriteService.unfavoriteArticle(decodedAccessToken, slug);
    return { article };
  }
}
