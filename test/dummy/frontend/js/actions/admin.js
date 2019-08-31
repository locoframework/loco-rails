/*
 * action types
 */

export const PREPEND_ARTICLES = "PREPEND_ARTICLES";

/*
 * action creators
 */

export function prependArticles(articles) {
  return { type: PREPEND_ARTICLES, payload: { articles } };
}
