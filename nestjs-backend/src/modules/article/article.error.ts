import { BadRequestException, ForbiddenException, NotFoundException } from '@nestjs/common';

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

export class ArticleAccessForbiddenError extends ForbiddenException {
  static code = 'article_access_forbidden';
  static message = 'Access denied: You do not have permission to access this article';
  constructor() {
    super(ArticleAccessForbiddenError.message, ArticleAccessForbiddenError.code);
  }
}

export class ArticleInputNotProvidedError extends BadRequestException {
  static code = 'article_input_not_provided';
  static message = 'Article input is not provided. Please try again with the valid input.';
  constructor() {
    super(ArticleInputNotProvidedError.message, ArticleInputNotProvidedError.code);
  }
}
