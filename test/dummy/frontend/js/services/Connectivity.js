import { Views } from "loco-js";

import store from "stores/main";
import { findArticle } from "reducers/main";
import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";

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
        const article = findArticle(store.getState(), data.id);
        const index = store.getState().articles.indexOf(article);
        if (!article) break;
        Article.find({ id: data.id, abbr: true }).then(article =>
          store.dispatch({
            type: "UPDATE",
            payload: { article: article, index: index }
          })
        );
        break;
      }
    }
  }

  call() {
    this.connectWith([Article, Comment]);
  }
}

export default Connectivity;
