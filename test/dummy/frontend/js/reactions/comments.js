import { helpers } from "simplicit";

import Comment from "models/article/Comment";
import { mainNamespace } from "services/namespace";
import { commentsUpdated } from "reactions/articles";

// Every page that lists comments is article-scoped, so the id in the URL is
// the article whose comments are on screen. Without this, a comment on another
// article would join the collection and render in the wrong list.
const onArticlePage = (articleId) => helpers.params.id === articleId;

export const created = async (payload) => {
  const { article_id: articleId, id } = payload;
  commentsUpdated(payload);
  if (!onArticlePage(articleId)) return;

  const findParams = { articleId, id };
  if (mainNamespace()) findParams.resource = "main";
  const comment = await Comment.find(findParams);
  if (comment === null) return;
  Comment.add(comment);
};

export const destroyed = (payload) => {
  Comment.byId(payload.id)?.del();
  commentsUpdated(payload);
};

export const updated = async ({ id }) => {
  const record = Comment.byId(id);
  if (!record) return;
  record.update(await record.reload());
};
