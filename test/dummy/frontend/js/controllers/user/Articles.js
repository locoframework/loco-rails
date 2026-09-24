import { helpers } from "simplicit";

import { renderFlash } from "services/app";
import FormView from "views/user/articles/Form";

import Article from "models/Article";
import Base from "controllers/Base";

export default class Articles extends Base {
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
