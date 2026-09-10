import { helpers } from "simplicit";

import Comment from "models/article/Comment";
import { mainNamespace } from "services/namespace";
import { commentsUpdated } from "reactions/articles";

// Every page that lists comments is article-scoped, so the id in the URL is
// the article whose comments are on screen. Without this, a comment on another
// article would join the collection and render in the wrong list.
const onArticlePage = (articleId) => helpers.params.id === articleId;

export const created = async ({ article_id: articleId, id }) => {
  commentsUpdated({ article_id: articleId }, 1);
  if (!onArticlePage(articleId)) return;

  const findParams = { articleId, id };
  if (mainNamespace()) findParams.resource = "main";
  const comment = await Comment.find(findParams);
  if (comment === null) return;
  Comment.add(comment);
};

export const destroyed = ({ article_id: articleId, id }) => {
  Comment.byId(id)?.del();
  commentsUpdated({ article_id: articleId }, -1);
};

export const updated = async ({ id }) => {
  const record = Comment.byId(id);
  if (!record) return;
  record.update(await record.reload());
};
