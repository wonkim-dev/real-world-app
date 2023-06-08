import { BadRequestException, NotFoundException } from '@nestjs/common';

export class ArticleNotFoundError extends NotFoundException {
  static code = 'article_not_found';
  static message = 'Article does not exist.';
  constructor() {
    super(ArticleNotFoundError.message, ArticleNotFoundError.code);
  }
}

export class ArticleMissingQueryStringError extends BadRequestException {
  static code = 'missing_query_string';
  static message = 'Required query string is missing.';
  constructor() {
    super(ArticleMissingQueryStringError.message, ArticleMissingQueryStringError.code);
  }
}

export class ArticleQueryStringInvalidValueTypeError extends BadRequestException {
  static code = 'invalid_query_string_value_type';
  constructor(queryStringKey: string, queryStringValueType: string) {
    const message = `Value for query string '${queryStringKey}' must be ${queryStringValueType}.`;
    super(message, ArticleQueryStringInvalidValueTypeError.code);
  }
}
