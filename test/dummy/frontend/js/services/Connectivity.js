import { Env, Views } from "loco-js";

import mainStore from "stores/main";
import adminStore from "stores/admin";
import { findArticle, findComment } from "selectors/articles";

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
        type: "ADD_ARTICLES",
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

const commentCreated = ({ article_id: articleId, id }) => {
  const [article] = findArticle(mainStore.getState(), articleId);
  if (!article) return;
  Comment.find({ articleId, id }).then(comment =>
    mainStore.dispatch({
      type: "ADD_COMMENTS",
      payload: { articleId, comments: [comment] }
    })
  );
};

const commentDestroyed = ({ article_id: articleId, id }) => {
  mainStore.dispatch({
    type: "REMOVE_COMMENT",
    payload: { id, articleId }
  });
};

const commentUpdated = ({ article_id: articleId, id }) => {
  const [comment, index] = findComment(mainStore.getState(), id, {
    subResourceId: articleId
  });
  if (!comment) return;
  comment.reload().then(() => {
    comment.applyChanges();
    mainStore.dispatch({
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
