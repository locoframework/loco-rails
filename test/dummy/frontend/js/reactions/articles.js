import { helpers } from "simplicit";

import Article from "models/Article";
import {
  adminNamespace,
  mainNamespace,
  userNamespace,
} from "services/namespace";
import { renderFlash } from "services/app";

const findParams = (id) => {
  const params = { id };
  if (helpers.params.id !== id) params.abbr = true;
  if (adminNamespace()) params.resource = "admin";
  return params;
};

export const created = async ({ id }) => {
  if (!userNamespace()) return;
  Article.add(await Article.find(findParams(id)));
};

export const updating = ({ id }) => {
  if (!mainNamespace() || helpers.params.id !== id) return;
  renderFlash({
    warning:
      "Author is currently editing article. Be aware of possible changes.",
  });
};

export const published = async ({ id }) => {
  Article.add(await Article.find(findParams(id)));
};

export const destroyed = ({ id }) => {
  Article.byId(id)?.del();
  if (userNamespace() && helpers.params.id === id) {
    window.location.href = "/user/articles?message=deleted";
  }
};

export const updated = async ({ id }) => {
  const record = Article.byId(id);
  if (!record) return;
  record.update(await Article.find(findParams(id)));
};

export const commentsUpdated = ({
  article_id: articleId,
  comments_count: count,
}) => {
  if (count == null) return;
  Article.byId(articleId)?.update({ commentsCount: count });
};
