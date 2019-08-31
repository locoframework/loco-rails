/*
 * action types
 */

export const PREPEND_ARTICLES = "PREPEND_ARTICLES";

export const PREPEND_USERS = "PREPEND_USERS";
export const SET_USERS = "SET_USERS";

/*
 * action creators
 */

export function prependArticles(articles) {
  return { type: PREPEND_ARTICLES, payload: { articles } };
}

export function prependUsers(users) {
  return { type: PREPEND_USERS, payload: { users } };
}

export function setUsers(users) {
  return { type: PREPEND_USERS, payload: { users } };
}
