import store from "store";
import { findArticle, findComment } from "selectors";
import Comment from "models/article/Comment";
import { mainNamespace } from "services/namespace";
import { commentsUpdated } from "reactions/articles";

export const created = async ({ article_id: articleId, id }) => {
  const findParams = { articleId, id };
  if (mainNamespace()) findParams.resource = "main";
  const article = findArticle(store.getState(), articleId);
  if (!article) return;
  const comment = await Comment.find(findParams);
  if (comment === null) return;
  store.dispatch({ type: "COMMENTS.ADD", comments: [comment], articleId });
  commentsUpdated({ article_id: articleId }, 1);
};

export const destroyed = ({ article_id: articleId, id }) => {
  store.dispatch({ type: "COMMENT.REMOVE", id, articleId });
};

export const updated = async ({ article_id: articleId, id }) => {
  const comment = findComment(store.getState(), id, { parentId: articleId });
  if (!comment) return;
  const reloadedComment = await comment.reload();
  store.dispatch({
    type: "COMMENT.UPDATE",
    comment: reloadedComment,
    articleId,
  });
};
