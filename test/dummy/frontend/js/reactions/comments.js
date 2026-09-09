import store from "store";
import { findArticle, findComment } from "selectors";
import Article from "models/Article";
import Comment from "models/article/Comment";
import { mainNamespace } from "services/namespace";
import { commentsUpdated } from "reactions/articles";

export const created = async ({ article_id: articleId, id }) => {
  const findParams = { articleId, id };
  if (mainNamespace()) findParams.resource = "main";
  const article =
    Article.byId(articleId) ?? findArticle(store.getState(), articleId);
  if (!article) return;
  const comment = await Comment.find(findParams);
  if (comment === null) return;
  Comment.add(comment);
  store.dispatch({ type: "COMMENTS.ADD", comments: [comment], articleId });
  commentsUpdated({ article_id: articleId }, 1);
};

export const destroyed = ({ article_id: articleId, id }) => {
  Comment.byId(id)?.del();
  store.dispatch({ type: "COMMENTS.REMOVE", id, articleId });
  commentsUpdated({ article_id: articleId }, -1);
};

export const updated = async ({ article_id: articleId, id }) => {
  const record = Comment.byId(id);
  const existing = findComment(store.getState(), id, { parentId: articleId });
  if (!record && !existing) return;
  const reloadedComment = await (record ?? existing).reload();
  record?.update(reloadedComment);
  if (existing)
    store.dispatch({
      type: "COMMENTS.UPDATE",
      comment: reloadedComment,
      articleId,
    });
};
