/*
 * action types
 */

export const REMOVE_ARTICLE = "REMOVE_ARTICLE";

/*
 * action creators
 */

export function removeArticle(id) {
  return { type: REMOVE_ARTICLE, payload: { id } };
}
