import { Views } from "loco-js";

import store from "stores/main";
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
        return;
    }
  }

  call() {
    this.connectWith([Article, Comment]);
  }
}

export default Connectivity;
