import { ArticleService } from './article.service';

describe('ArticleService', () => {
  let articleService: any;
  const articleWithRelation = {
    articleId: 1,
    slug: 'article-e2e-test-2d0e2d83',
    title: 'Article e2e test',
    description: 'This is article for e2e test',
    body: 'This article is used for e2e test.',
    fkUserId: 'c9c01faf-4e07-4f9b-973b-1d401c36042c',
    createdAt: new Date(Date.now() - 1000 * 3600 * 24),
    updatedAt: new Date(),
    userByFkUserId: {
      userId: 'c9c01faf-4e07-4f9b-973b-1d401c36042c',
      username: 'testadmin',
      email: 'testadmin@email.com',
      bio: 'I am testadmin',
      avatarPath: 'users/c9c01faf-4e07-4f9b-973b-1d401c36042c/avatar.png',
      createdAt: new Date(Date.now() - 1000 * 3600 * 24 * 5),
      updateAt: new Date(Date.now() - 1000 * 3600 * 24 * 4),
    },
    articleTagMappingsByFkArticleId: [
      {
        articleTagMappingId: 2,
        fkArticleId: 1,
        fkTagId: 3,
        createdAt: new Date(Date.now() - 1000 * 3600 * 24 * 3),
        updatedAt: new Date(Date.now() - 1000 * 3600 * 24 * 2),
        tagByFkTagId: { tagId: 3, name: 'e2e-test', createdAt: '2023-06-06T22:26:36.620Z', updatedAt: '2023-06-06T22:26:36.620Z' },
      },
    ],
    articleUserMappingsByFkArticleId: [{ articleUserMappingId: 4, fkArticleId: 1, favoritedByFkUserId: 'randomUserId' }],
  };

  beforeEach(() => {
    articleService = new ArticleService({} as any, {} as any);
  });

  describe('getArticleData', () => {
    it('should return articleData', () => {
      // ARRANGE
      const username = 'randomUserId';
      // ACT
      const result = articleService.getArticleData(articleWithRelation, username);
      // ASSERT
      expect(result).toEqual(
        expect.objectContaining({
          slug: articleWithRelation.slug,
          title: articleWithRelation.title,
          description: articleWithRelation.description,
          body: articleWithRelation.body,
          favorited: articleWithRelation.articleUserMappingsByFkArticleId.find(
            (articleUserMapping) => (articleUserMapping.favoritedByFkUserId = username)
          )
            ? true
            : false,
          favoritesCount: articleWithRelation.articleUserMappingsByFkArticleId.length,
          tagList: articleWithRelation.articleTagMappingsByFkArticleId.map((articleTagMapping) => articleTagMapping.tagByFkTagId.name),
          createdAt: articleWithRelation.createdAt.toISOString(),
          updatedAt: articleWithRelation.updatedAt.toISOString(),
          author: null,
        })
      );
    });
  });

  describe('getMissingTagsPayload', () => {
    it('should get insert payload for Tag', () => {
      // ARRANGE
      const tagList = ['tag1', 'tag2', 'tag3', 'tag4'];
      const existingTagNames = ['tag2', 'tag3'];
      // ACT
      const result = articleService.getMissingTagsPayload(tagList, existingTagNames);
      // ASSERT
      expect(result).toEqual(expect.arrayContaining([{ name: 'tag1' }, { name: 'tag4' }]));
    });
  });

  describe('getArticleTagMappingsPayload', () => {
    it('should get insert payload for ArticleTagMapping', () => {
      // ARRANGE
      const article = { articleId: 1 };
      const tags = [{ tagId: 2 }, { tagId: 3 }];
      // ACT
      const result = articleService.getArticleTagMappingsPayload(article, tags);
      // ASSERT
      expect(result).toEqual(
        expect.arrayContaining([
          { fkArticleId: article.articleId, fkTagId: tags[0].tagId },
          { fkArticleId: article.articleId, fkTagId: tags[0].tagId },
        ])
      );
    });
  });

  describe('generateUniqueSlug', () => {
    it('should generate a slug with uuid suffix', () => {
      // ARRANGE
      const title = 'test title';
      const regex = /^test-title.+/;
      // ACT
      const result = articleService.generateUniqueSlug(title);
      // ASSERT
      expect(result).toMatch(regex);
    });
  });
});
