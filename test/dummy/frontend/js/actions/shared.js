/*
 * action types
 */

export const ADD_ARTICLES = "ADD_ARTICLES";
export const SET_ARTICLES = "SET_ARTICLES";
export const UPDATE_ARTICLE = "UPDATE_ARTICLE";

export const ADD_COMMENTS = "ADD_COMMENTS";
/*
 * action creators
 */

export function addArticles(articles) {
  return { type: ADD_ARTICLES, payload: { articles } };
}

export function setArticles(articles) {
  return { type: SET_ARTICLES, payload: { articles } };
}

export function updateArticle(article, index) {
  return { type: UPDATE_ARTICLE, payload: { article, index } };
}

export function addComments(comments, articleId) {
  return { type: ADD_COMMENTS, payload: { articleId, comments } };
}
