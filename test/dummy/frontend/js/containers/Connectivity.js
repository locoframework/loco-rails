import { Views } from "loco-js";

import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";

class Connectivity extends Views.Base {
  constructor(opts = {}) {
    super(opts);
    this.callbacks = null;
  }

  receivedSignal(signal, data) {
    switch (signal) {
      case "Article published":
        Article.find({ id: data.id, abbr: true }).then(article =>
          this.callbacks.onArticlePublished(article)
        );
        return;
    }
  }

  call({ callbacks }) {
    if (this.callbacks) return;
    this.callbacks = callbacks;
    this.connectWith([Article, Comment]);
  }
}

export default Connectivity;
