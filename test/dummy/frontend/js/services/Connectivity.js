import { Env, Views } from "loco-js";

import mainStore from "stores/main";
import adminStore from "stores/admin";
import { findArticle } from "selectors/articles";

import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";
import User from "models/user.coffee";

import AdminController from "controllers/Admin";

const articlePublished = ({ id }) => {
  if (Env.namespaceController.constructor === AdminController) {
    Article.find({ id, abbr: true, resource: "admin" }).then(article => {
      adminStore.dispatch({
        type: "PREPEND_ARTICLE",
        payload: { articles: [article] }
      });
    });
  } else {
    Article.find({ id, abbr: true }).then(article => {
      mainStore.dispatch({
        type: "ADD",
        payload: { articles: [article] }
      });
    });
  }
};

const articleUpdated = ({ id }) => {
  const findParams = { id: id, abbr: true };
  let store = mainStore;

  if (Env.namespaceController.constructor === AdminController) {
    findParams["resource"] = "admin";
    store = adminStore;
  }

  const [article, index] = findArticle(store.getState(), id);
  if (!article) return;
  Article.find(findParams).then(article =>
    store.dispatch({
      type: "UPDATE_ARTICLE",
      payload: { article, index }
    })
  );
};

const commentsChanged = ({ article_id: articleId }, diff) => {
  let store = mainStore;
  if (Env.namespaceController.constructor === AdminController) {
    store = adminStore;
  }
  const [article, index] = findArticle(store.getState(), articleId);
  if (!article) return;
  store.dispatch({
    type: "UPDATE_ARTICLE",
    payload: {
      article: new Article({
        ...article,
        commentsCount: article.commentsCount + diff
      }),
      index: index
    }
  });
};

class Connectivity extends Views.Base {
  constructor(opts = {}) {
    super(opts);
  }

  receivedSignal(signal, data) {
    switch (signal) {
      case "Article published":
        articlePublished(data);
        break;
      case "Article updated":
        articleUpdated(data);
        break;
      case "Article.Comment created":
        commentsChanged(data, 1);
        break;
      case "Article.Comment destroyed":
        commentsChanged(data, -1);
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
