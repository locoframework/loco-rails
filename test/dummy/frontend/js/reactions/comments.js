import Comment from "models/article/Comment";
import { mainNamespace } from "services/namespace";
import { commentsUpdated, onArticlePage } from "reactions/articles";

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
