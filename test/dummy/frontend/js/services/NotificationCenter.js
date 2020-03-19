import { Env } from "loco-js";

import {
  addArticles,
  prependArticles,
  updateArticle,
  addComments,
  prependUsers,
  removeComment,
  updateComment
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
  if (Env.namespaceController.constructor !== UserController) return;
  const article = await Article.find({ id, abbr: true });
  store.dispatch(addArticles([article]));
};

const articlePublished = async ({ id }) => {
  if (Env.namespaceController.constructor === AdminController) {
    const article = await Article.find({ id, abbr: true, resource: "admin" });
    store.dispatch(prependArticles([article]));
  } else {
    const article = await Article.find({ id, abbr: true });
    store.dispatch(addArticles([article]));
  }
};

const articleUpdated = async ({ id }) => {
  const findParams = { id: id, abbr: true };
  if (Env.namespaceController.constructor === AdminController) {
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
    commentsCount: article.commentsCount + diff
  });
  store.dispatch(updateArticle(updatedArticle, index));
};

const commentCreated = async ({ article_id: articleId, id }) => {
  const findParams = { articleId, id };
  if (Env.namespaceController.constructor === MainController) {
    findParams["resource"] = "main";
  }
  const [article] = findArticle(store.getState(), articleId);
  if (!article) return;
  const comment = await Comment.find(findParams);
  store.dispatch(addComments([comment], articleId));
};

const commentDestroyed = ({ article_id: articleId, id }) => {
  store.dispatch(removeComment(id, articleId));
};

const commentUpdated = async ({ article_id: articleId, id }) => {
  const [comment, index] = findComment(store.getState(), id, {
    parentId: articleId
  });
  if (!comment) return;
  await comment.reload();
  comment.applyChanges();
  store.dispatch(updateComment(new Comment({ ...comment }), articleId, index));
};

const pingSignal = () => {
  if (Env.namespaceController.constructor !== UserController) return;
  alert("Ping!");
};

const getRoomView = () => {
  if (Env.namespaceController.constructor !== UserController) return false;
  if (Env.controller.constructor !== RoomsController) return false;
  if (Env.action !== "show") return false;
  return Env.controller.getView("receivedMessage");
};

const messageSignal = data => {
  const receivedMessage = getRoomView();
  if (!receivedMessage) return;
  receivedMessage(data.message, data.author);
};

export default async data => {
  switch (data.signal) {
    case "ping":
      pingSignal();
      break;
    case "message":
      messageSignal(data);
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
      commentsChanged(data.payload, 1);
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
