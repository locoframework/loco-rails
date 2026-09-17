import { helpers } from "simplicit";

import { renderFlash } from "services/app";
import FormView from "views/user/articles/Form";

import Article from "models/Article";

class Articles {
  initialize() {
    this.unsubscribe = null;
  }

  deinitialize() {
    if (this.unsubscribe !== null) {
      this.unsubscribe();
      this.unsubscribe = null;
    }
  }

  index() {
    if (helpers.params.message === "deleted") {
      renderFlash({ alert: "Article has been deleted." });
    }
  }

  new() {
    this.unsubscribe = FormView.render(new Article());
  }

  // A detached copy, because this form offers "apply changes": `changes()`
  // diffs the object against the server's copy, so the two have to be able to
  // drift apart. Sharing the collection record — which reactions/articles
  // refreshes in place — makes that diff permanently empty.
  edit() {
    this.unsubscribe = FormView.render(Article.byId(helpers.params.id).clone());
  }
}

export default Articles;
