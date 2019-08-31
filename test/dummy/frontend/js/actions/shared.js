/*
 * action types
 */

export const ADD_ARTICLES = "ADD_ARTICLES";
export const SET_ARTICLES = "SET_ARTICLES";

/*
 * action creators
 */

export function addArticles(articles) {
  return { type: ADD_ARTICLES, payload: { articles } };
}

export function setArticles(articles) {
  return { type: SET_ARTICLES, payload: { articles } };
}
