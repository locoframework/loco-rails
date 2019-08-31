import { Env, Views } from "loco-js";

import { prependArticles } from "actions/admin";
import { addArticles, updateArticle } from "actions/shared";
import adminStore from "stores/admin";
import mainStore from "stores/main";
import userStore from "stores/user";
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
    userStore.dispatch(addArticles([article]))
  );
};

const articlePublished = ({ id }) => {
  if (Env.namespaceController.constructor === AdminController) {
    Article.find({ id, abbr: true, resource: "admin" }).then(article => {
      adminStore.dispatch(prependArticles([article]));
    });
  } else {
    Article.find({ id, abbr: true }).then(article =>
      mainStore.dispatch(addArticles([article]))
    );
  }
};

const articleUpdated = ({ id }) => {
  const findParams = { id: id, abbr: true };
  let store = mainStore;

  if (Env.namespaceController.constructor === AdminController) {
    findParams["resource"] = "admin";
    store = adminStore;
  } else if (Env.namespaceController.constructor === UserController) {
    store = userStore;
  }

  const [article, index] = findArticle(store.getState(), id);
  if (!article) return;
  Article.find(findParams).then(article =>
    store.dispatch(updateArticle(article, index))
  );
};

const commentsChanged = ({ article_id: articleId }, diff) => {
  let store = mainStore;
  if (Env.namespaceController.constructor === AdminController) {
    store = adminStore;
  } else if (Env.namespaceController.constructor === UserController) {
    store = userStore;
  }
  const [article, index] = findArticle(store.getState(), articleId);
  if (!article) return;
  const updatedArticle = new Article({
    ...article,
    commentsCount: article.commentsCount + diff
  });
  store.dispatch(updateArticle(updatedArticle, index));
};

const commentCreated = ({ article_id: articleId, id }) => {
  let store = userStore;
  const findParams = { articleId, id };

  if (Env.namespaceController.constructor === MainController) {
    store = mainStore;
    findParams["resource"] = "main";
  }
  const [article] = findArticle(store.getState(), articleId);
  if (!article) return;
  Comment.find(findParams).then(comment =>
    store.dispatch({
      type: "ADD_COMMENTS",
      payload: { articleId, comments: [comment] }
    })
  );
};

const commentDestroyed = ({ article_id: articleId, id }) => {
  let store = mainStore;
  if (Env.namespaceController.constructor === UserController) {
    store = userStore;
  }
  store.dispatch({
    type: "REMOVE_COMMENT",
    payload: { id, articleId }
  });
};

const commentUpdated = ({ article_id: articleId, id }) => {
  let store = mainStore;
  if (Env.namespaceController.constructor === UserController) {
    store = userStore;
  }
  const [comment, index] = findComment(store.getState(), id, {
    parentId: articleId
  });
  if (!comment) return;
  comment.reload().then(() => {
    comment.applyChanges();
    store.dispatch({
      type: "UPDATE_COMMENT",
      payload: { comment, index, articleId }
    });
  });
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
        User.find(data.id).then(user =>
          adminStore.dispatch({
            type: "PREPEND_USER",
            payload: { users: [user] }
          })
        );
        break;
    }
  }

  call() {
    this.connectWith([Article, Comment, User]);
  }
}

export default Connectivity;
