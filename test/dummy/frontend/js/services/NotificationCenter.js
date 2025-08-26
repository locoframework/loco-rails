import getEnv from "initializers/loco-core";

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

const userNamespace = () => {
  return getEnv().namespaceController.constructor === UserController;
};

const adminNamespace = () => {
  return getEnv().namespaceController.constructor === AdminController;
};

const mainNamespace = () => {
  return getEnv().namespaceController.constructor === MainController;
};

const inChatRoom = () => {
  return (
    userNamespace() &&
    getEnv().controller !== null &&
    getEnv().controller.constructor === RoomsController &&
    getEnv().action === "show"
  );
};

const articleCreated = async ({ id }) => {
  if (!userNamespace()) return;
  const article = await Article.find({ id, abbr: true });
  store.dispatch(addArticles([article]));
};

const articlePublished = async ({ id }) => {
  if (adminNamespace()) {
    const article = await Article.find({ id, abbr: true, resource: "admin" });
    store.dispatch(prependArticles([article]));
  } else {
    const article = await Article.find({ id, abbr: true });
    store.dispatch(addArticles([article]));
  }
};

const articleUpdated = async ({ id }) => {
  const findParams = { id: id, abbr: true };
  if (adminNamespace()) {
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
  if (mainNamespace()) {
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
  if (!userNamespace()) return;
  alert("Ping!");
};

const getCallbackForNewMessage = () => {
  if (!inChatRoom()) return () => {};
  return getEnv().controller.view.receivedMessage;
};

const wsDisconnected = () => {
  if (inChatRoom()) {
    getEnv().controller.view.disconnected();
  }
};

export default async (data) => {
  if (data.loco !== undefined) {
    switch (data.loco) {
      case "disconnected":
        wsDisconnected();
        break;
    }
  }
  switch (data.type) {
    case "PING":
      ping();
      break;
    case "NEW_MESSAGE":
      getCallbackForNewMessage()(data.message, data.author);
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
    case "USER_CONFIRMED":
      window.location.href = "/user/sessions/new?event=confirmed";
      break;
    case "User created": {
      const user = await User.find(data.payload.id);
      store.dispatch(prependUsers([user]));
      break;
    }
  }
};
