import store from "store";
import { findArticle } from "selectors";
import Article from "models/Article";
import { adminNamespace, userNamespace } from "services/namespace";

// Article is a Simplicit Model: add/update/del re-render the components bound
// to each record. Redux is still fed for the parts not migrated yet.
const findParams = (id) => {
  const params = { id, abbr: true };
  if (adminNamespace()) params.resource = "admin";
  return params;
};

export const created = async ({ id }) => {
  if (!userNamespace()) return;
  const article = await Article.find({ id, abbr: true });
  store.dispatch({ type: "ARTICLES.ADD", articles: [article] });
};

export const published = async ({ id }) => {
  const article = await Article.find(findParams(id));
  Article.add(article);
  store.dispatch({ type: "ARTICLES.ADD", articles: [article] });
};

export const destroyed = ({ id }) => {
  Article.byId(id)?.del();
  store.dispatch({ type: "ARTICLES.REMOVE", id });
};

export const updated = async ({ id }) => {
  const record = Article.byId(id);
  const existing = findArticle(store.getState(), id);
  if (!record && !existing) return;
  const article = await Article.find(findParams(id));
  record?.update(article);
  if (existing) store.dispatch({ type: "ARTICLES.UPDATE", article });
};

export const commentsUpdated = ({ article_id: articleId }, diff) => {
  const record = Article.byId(articleId);
  record?.update({ commentsCount: record.commentsCount + diff });

  const article = findArticle(store.getState(), articleId);
  if (!article) return;
  store.dispatch({
    type: "ARTICLES.UPDATE",
    article: { id: articleId, commentsCount: article.commentsCount + diff },
  });
};
