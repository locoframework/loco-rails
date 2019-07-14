import { Env, Views } from "loco-js";

import mainStore from "stores/main";
import adminStore from "stores/admin";
import { findArticle } from "reducers/main";

import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";
import User from "models/user.coffee";

import AdminController from "controllers/admin.coffee";

const commentsChanged = (articleId, diff) => {
  const [article, index] = findArticle(mainStore.getState(), articleId);
  if (!article) return;
  mainStore.dispatch({
    type: "UPDATE",
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
        if (Env.namespaceController.constructor === AdminController) {
          Article.find({ id: data.id, abbr: true, resource: "admin" }).then(
            article => {
              adminStore.dispatch({
                type: "PREPEND_ARTICLE",
                payload: { articles: [article] }
              });
            }
          );
        } else {
          Article.find({ id: data.id, abbr: true }).then(article => {
            mainStore.dispatch({
              type: "ADD",
              payload: { articles: [article] }
            });
          });
        }
        break;
      case "Article updated": {
        const [article, index] = findArticle(mainStore.getState(), data.id);
        if (!article) break;
        Article.find({ id: data.id, abbr: true }).then(article =>
          mainStore.dispatch({
            type: "UPDATE",
            payload: { article: article, index: index }
          })
        );
        break;
      }
      case "Article.Comment created":
        commentsChanged(data.article_id, 1);
        break;
      case "Article.Comment destroyed":
        commentsChanged(data.article_id, -1);
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
