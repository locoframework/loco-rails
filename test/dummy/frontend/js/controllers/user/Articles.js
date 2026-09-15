import { helpers } from "simplicit";

import { inlineOne } from "utils/inline";
import renderFlash from "views/shared/Flash";
import ShowView from "views/user/articles/Show";
import FormView from "views/user/articles/Form";

import Article from "models/Article";

const renderArticle = () => {
  const article = inlineOne("article-data", Article);
  ShowView(article);
};

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

  show() {
    renderArticle();
  }

  new() {
    this.unsubscribe = FormView.render(new Article());
  }

  edit() {
    this.unsubscribe = FormView.render(inlineOne("article-data", Article));
  }
}

export default Articles;
