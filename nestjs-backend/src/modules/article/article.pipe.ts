import { PipeTransform, Injectable } from '@nestjs/common';
import { isNaN, isNil, toNumber } from 'lodash';
import { ArticleQueryStringInvalidValueTypeError } from './article.error';

@Injectable()
export class ParseArticleLimitIntPipe implements PipeTransform<string, number> {
  transform(value: any) {
    if (isNil(value)) {
      return 20;
    }
    if (isNaN(toNumber(value))) {
      throw new ArticleQueryStringInvalidValueTypeError('limit', 'integer');
    }

    return Math.floor(toNumber(value));
  }
}

@Injectable()
export class ParseArticleOffsetIntPipe implements PipeTransform<string, number> {
  transform(value: any) {
    if (isNil(value)) {
      return 0;
    }
    if (isNaN(toNumber(value))) {
      throw new ArticleQueryStringInvalidValueTypeError('offset', 'integer');
    }
    return Math.floor(toNumber(value));
  }
}
