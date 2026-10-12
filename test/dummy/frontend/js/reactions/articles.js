import { helpers } from "simplicit";

import AdminArticles from "controllers/admin/Articles";
import MainArticles from "controllers/main/Articles";
import UserArticles from "controllers/user/Articles";
import getEnv from "initializers/simplicit";
import Article from "models/Article";
import { userNamespace } from "services/namespace";
import { renderFlash } from "services/app";

const ARTICLES_CONTROLLERS = [AdminArticles, MainArticles, UserArticles];

export const onArticlePage = (id) =>
  ARTICLES_CONTROLLERS.some((c) => getEnv().controller instanceof c) &&
  helpers.params.id === id;

const findParams = (id) => (onArticlePage(id) ? id : { id, abbr: true });

export const created = async ({ id }) => {
  if (!userNamespace()) return;
  Article.add(await Article.find(id));
};

export const updating = ({ id }) => {
  if (getEnv().controller instanceof MainArticles && helpers.params.id === id)
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
  const { controller, action } = getEnv();
  const viewing =
    controller instanceof UserArticles && ["show", "edit"].includes(action);
  if (viewing && helpers.params.id === id) {
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
  Article.byId(articleId)?.update({ commentsCount: count });
};
