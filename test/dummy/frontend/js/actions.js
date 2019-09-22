/*
 * action types
 */

export const ADD_ARTICLES = "ADD_ARTICLES";
export const PREPEND_ARTICLES = "PREPEND_ARTICLES";
export const REMOVE_ARTICLE = "REMOVE_ARTICLE";
export const SET_ARTICLES = "SET_ARTICLES";
export const UPDATE_ARTICLE = "UPDATE_ARTICLE";

export const ADD_COMMENTS = "ADD_COMMENTS";
export const REMOVE_COMMENT = "REMOVE_COMMENT";
export const SET_COMMENTS = "SET_COMMENTS";
export const UPDATE_COMMENT = "UPDATE_COMMENT";

export const PREPEND_USERS = "PREPEND_USERS";
export const SET_USERS = "SET_USERS";

/*
 * action creators
 */

export function addArticles(articles) {
  return { type: ADD_ARTICLES, payload: { articles } };
}

export function prependArticles(articles) {
  return { type: PREPEND_ARTICLES, payload: { articles } };
}

export function removeArticle(id) {
  return { type: REMOVE_ARTICLE, payload: { id } };
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

export function removeComment(id, articleId) {
  return { type: REMOVE_COMMENT, payload: { id, articleId } };
}

export function setComments(comments, articleId) {
  return { type: SET_COMMENTS, payload: { comments, articleId } };
}

export function updateComment(comment, articleId, index) {
  return { type: UPDATE_COMMENT, payload: { comment, articleId, index } };
}

export function prependUsers(users) {
  return { type: PREPEND_USERS, payload: { users } };
}

export function setUsers(users) {
  return { type: PREPEND_USERS, payload: { users } };
}
