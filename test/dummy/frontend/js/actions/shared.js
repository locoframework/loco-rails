/*
 * action types
 */

export const ADD_ARTICLES = "ADD_ARTICLES";

/*
 * action creators
 */

export function addArticles(articles) {
  return { type: ADD_ARTICLES, payload: { articles } };
}
