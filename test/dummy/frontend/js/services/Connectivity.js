import { Views } from "loco-js";

import store from "stores/main";
import { findArticle } from "reducers/main";
import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";

const commentsChanged = (articleId, diff) => {
  const [article, index] = findArticle(store.getState(), articleId);
  if (!article) return;
  store.dispatch({
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
        Article.find({ id: data.id, abbr: true }).then(article =>
          store.dispatch({ type: "ADD", payload: { articles: [article] } })
        );
        break;
      case "Article updated": {
        const [article, index] = findArticle(store.getState(), data.id);
        if (!article) break;
        Article.find({ id: data.id, abbr: true }).then(article =>
          store.dispatch({
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
    }
  }

  call() {
    this.connectWith([Article, Comment]);
  }
}

export default Connectivity;
