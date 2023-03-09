import loco from "initializers/loco";

import {
  addArticles,
  prependArticles,
  updateArticle,
  addComments,
  prependUsers,
  removeComment,
  updateComment,
} from "actions";
import store from "store";
import { findArticle, findComment } from "selectors/articles";

import Article from "models/Article";
import Comment from "models/article/Comment";
import User from "models/User";

import AdminController from "controllers/Admin";
import MainController from "controllers/Main";
import RoomsController from "controllers/user/Rooms";
import UserController from "controllers/User";

const articleCreated = async ({ id }) => {
  if (loco.getEnv().namespaceController.constructor !== UserController) return;
  const article = await Article.find({ id, abbr: true });
  store.dispatch(addArticles([article]));
};

const articlePublished = async ({ id }) => {
  if (loco.getEnv().namespaceController.constructor === AdminController) {
    const article = await Article.find({ id, abbr: true, resource: "admin" });
    store.dispatch(prependArticles([article]));
  } else {
    const article = await Article.find({ id, abbr: true });
    store.dispatch(addArticles([article]));
  }
};

const articleUpdated = async ({ id }) => {
  const findParams = { id: id, abbr: true };
  if (loco.getEnv().namespaceController.constructor === AdminController) {
    findParams["resource"] = "admin";
  }
  let [article, index] = findArticle(store.getState(), id);
  if (!article) return;
  article = await Article.find(findParams);
  store.dispatch(updateArticle(article, index));
};

const commentsChanged = ({ article_id: articleId }, diff) => {
  const [article, index] = findArticle(store.getState(), articleId);
  if (!article) return;
  const updatedArticle = new Article({
    ...article,
    commentsCount: article.commentsCount + diff,
  });
  store.dispatch(updateArticle(updatedArticle, index));
};

const commentCreated = async ({ article_id: articleId, id }) => {
  const findParams = { articleId, id };
  if (loco.getEnv().namespaceController.constructor === MainController) {
    findParams["resource"] = "main";
  }
  const [article] = findArticle(store.getState(), articleId);
  if (!article) return;
  const comment = await Comment.find(findParams);
  if (comment === null) return;
  store.dispatch(addComments([comment], articleId));
  commentsChanged({ article_id: articleId }, 1);
};

const commentDestroyed = ({ article_id: articleId, id }) => {
  store.dispatch(removeComment(id, articleId));
};

const commentUpdated = async ({ article_id: articleId, id }) => {
  const [comment, index] = findComment(store.getState(), id, {
    parentId: articleId,
  });
  if (!comment) return;
  const reloadedComment = await comment.reload();
  store.dispatch(updateComment(reloadedComment, articleId, index));
};

const ping = () => {
  if (loco.getEnv().namespaceController.constructor !== UserController) return;
  alert("Ping!");
};

const getCallbackForReceivedMessage = () => {
  const nullCallback = () => {};
  if (loco.getEnv().namespaceController.constructor !== UserController)
    return nullCallback;
  if (loco.getEnv().controller.constructor !== RoomsController)
    return nullCallback;
  if (loco.getEnv().action !== "show") return nullCallback;
  return loco.getEnv().controller.callbacks["receivedMessage"];
};

export default async (data) => {
  switch (data.type) {
    case "PING":
      ping();
      break;
    case "NEW_MESSAGE":
      getCallbackForReceivedMessage()(data.message, data.author);
      break;
    case "Article created":
      articleCreated(data.payload);
      break;
    case "Article published":
      articlePublished(data.payload);
      break;
    case "Article updated":
      articleUpdated(data.payload);
      break;
    case "Article.Comment created":
      commentCreated(data.payload);
      break;
    case "Article.Comment destroyed":
      commentsChanged(data.payload, -1);
      commentDestroyed(data.payload);
      break;
    case "Article.Comment updated":
      commentUpdated(data.payload);
      break;
    case "User created": {
      const user = await User.find(data.payload.id);
      store.dispatch(prependUsers([user]));
      break;
    }
  }
};
