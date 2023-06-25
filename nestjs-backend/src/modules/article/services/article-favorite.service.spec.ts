import { ArticleFavoriteService } from './article-favorite.service';

describe('ArticleFavoriteService', () => {
  let articleFavoriteService: any;

  beforeEach(() => {
    articleFavoriteService = new ArticleFavoriteService({} as any, {} as any);
  });

  describe('buildArticleData', () => {
    it('should build article data response', () => {
      const article = {
        slug: 'article-test-slug',
        title: 'article-test-title',
        description: 'article-test-description',
        body: 'article-test-body',
        createdAt: new Date(),
        updatedAt: new Date(),
        articleTagMappingsByFkArticleId: [
          { tagByFkTagId: { name: 'article-test-tag-1' } },
          { tagByFkTagId: { name: 'article-test-tag-2' } },
        ],
        articleUserMappingsByFkArticleId: [
          { fkArticleId: 1, favoritedByFkUserId: 'article-test-user-1' },
          { fkArticleId: 2, favoritedByFkUserId: 'article-test-user-2' },
        ],
      };
      const res = articleFavoriteService.buildArticleData(article);
      expect(res).toEqual(
        expect.objectContaining({
          slug: article.slug,
          title: article.title,
          description: article.description,
          body: article.body,
          favorited: null,
          favoritesCount: 2,
          tagList: ['article-test-tag-1', 'article-test-tag-2'],
          createdAt: article.createdAt.toISOString(),
          updatedAt: article.updatedAt.toISOString(),
          author: null,
        })
      );
    });
  });
});
