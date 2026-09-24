import { UI } from "loco-js-ui";
import { helpers } from "simplicit";

import Article from "models/Article";

export default class Articles {
  edit() {
    const article = Article.byId(helpers.params.id);
    article.setDefaultValuesForAdminReview();
    new UI.Form({ id: "edit_article_form", for: article }).render();
  }
}
