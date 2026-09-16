import { helpers } from "simplicit";

import Comment from "models/article/Comment";
import renderForm from "views/main/articles/Form";

class Articles {
  show() {
    renderForm(new Comment({ articleId: helpers.params.id }));
  }
}

export default Articles;
