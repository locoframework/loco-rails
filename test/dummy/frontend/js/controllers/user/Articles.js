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

  edit() {
    this.unsubscribe = FormView.render(Article.byId(helpers.params.id).clone());
  }
}

export default Articles;
