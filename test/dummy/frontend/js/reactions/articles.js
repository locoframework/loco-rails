import store from "store";
import { findArticle } from "selectors";
import Article from "models/Article";
import { adminNamespace, userNamespace } from "services/namespace";

export const created = async ({ id }) => {
  if (!userNamespace()) return;
  const article = await Article.find({ id, abbr: true });
  store.dispatch({ type: "ARTICLES.ADD", articles: [article] });
};

export const published = async ({ id }) => {
  if (adminNamespace()) {
    const article = await Article.find({ id, abbr: true, resource: "admin" });
    store.dispatch({ type: "ARTICLES.PREPEND", articles: [article] });
  } else {
    const article = await Article.find({ id, abbr: true });
    store.dispatch({ type: "ARTICLES.ADD", articles: [article] });
  }
};

export const destroyed = ({ id }) => {
  store.dispatch({ type: "ARTICLE.REMOVE", id });
};

export const updated = async ({ id }) => {
  const findParams = { id, abbr: true };
  if (adminNamespace()) findParams.resource = "admin";
  const existing = findArticle(store.getState(), id);
  if (!existing) return;
  const article = await Article.find(findParams);
  store.dispatch({ type: "ARTICLE.UPDATE", article });
};

export const commentsUpdated = ({ article_id: articleId }, diff) => {
  const article = findArticle(store.getState(), articleId);
  if (!article) return;
  store.dispatch({
    type: "ARTICLE.UPDATE",
    article: { id: articleId, commentsCount: article.commentsCount + diff },
  });
};
