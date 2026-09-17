import { helpers } from "simplicit";

import Article from "models/Article";
import renderForm from "views/admin/articles/Form";

class Articles {
  edit() {
    renderForm(Article.byId(helpers.params.id));
  }
}

export default Articles;
