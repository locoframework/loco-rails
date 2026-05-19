import { createFinder } from "./createFinder";

export const findArticle = createFinder("articles");
export const findComment = createFinder("comments");

export const commentsForArticle = (state, articleId) =>
  state.comments[articleId];
