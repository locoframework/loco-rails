import Article from "models/Article";
import { adminNamespace, userNamespace } from "services/namespace";

const findParams = (id) => {
  const params = { id, abbr: true };
  if (adminNamespace()) params.resource = "admin";
  return params;
};

export const created = async ({ id }) => {
  if (!userNamespace()) return;
  Article.add(await Article.find({ id, abbr: true }));
};

export const published = async ({ id }) => {
  Article.add(await Article.find(findParams(id)));
};

export const destroyed = ({ id }) => {
  Article.byId(id)?.del();
};

export const updated = async ({ id }) => {
  const record = Article.byId(id);
  if (!record) return;
  record.update(await Article.find(findParams(id)));
};

export const commentsUpdated = ({ article_id: articleId }, diff) => {
  const record = Article.byId(articleId);
  record?.update({ commentsCount: record.commentsCount + diff });
};
