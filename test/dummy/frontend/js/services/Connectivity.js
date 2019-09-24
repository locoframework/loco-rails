import { Env, Views } from "loco-js";

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
import UserController from "controllers/User";

const articleCreated = ({ id }) => {
  if (Env.namespaceController.constructor !== UserController) return;
  Article.find({ id, abbr: true }).then(article =>
    store.dispatch(addArticles([article]))
  );
};

const articlePublished = ({ id }) => {
  if (Env.namespaceController.constructor === AdminController) {
    Article.find({ id, abbr: true, resource: "admin" }).then(article => {
      store.dispatch(prependArticles([article]));
    });
  } else {
    Article.find({ id, abbr: true }).then(article =>
      store.dispatch(addArticles([article]))
    );
  }
};

const articleUpdated = ({ id }) => {
  const findParams = { id: id, abbr: true };
  if (Env.namespaceController.constructor === AdminController) {
    findParams["resource"] = "admin";
  }
  const [article, index] = findArticle(store.getState(), id);
  if (!article) return;
  Article.find(findParams).then(article =>
    store.dispatch(updateArticle(article, index))
  );
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

const commentCreated = ({ article_id: articleId, id }) => {
  const findParams = { articleId, id };
  if (Env.namespaceController.constructor === MainController) {
    findParams["resource"] = "main";
  }
  const [article] = findArticle(store.getState(), articleId);
  if (!article) return;
  Comment.find(findParams).then(comment =>
    store.dispatch(addComments([comment], articleId))
  );
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

class Connectivity extends Views.Base {
  constructor(opts = {}) {
    super(opts);
  }

  receivedSignal(signal, data) {
    switch (signal) {
      case "Article created":
        articleCreated(data);
        break;
      case "Article published":
        articlePublished(data);
        break;
      case "Article updated":
        articleUpdated(data);
        break;
      case "Article.Comment created":
        commentsChanged(data, 1);
        commentCreated(data);
        break;
      case "Article.Comment destroyed":
        commentsChanged(data, -1);
        commentDestroyed(data);
        break;
      case "Article.Comment updated":
        commentUpdated(data);
        break;
      case "User created":
        User.find(data.id).then(user => store.dispatch(prependUsers([user])));
        break;
    }
  }

  call() {
    this.connectWith([Article, Comment, User]);
  }
}

export default Connectivity;
