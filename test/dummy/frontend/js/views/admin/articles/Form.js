import { Views, UI } from "loco-js";

class Form extends Views.Base {
  constructor(opts = {}) {
    super(opts);
  }

  render(article) {
    article.setDefaultValuesForAdminReview();
    const form = new UI.Form({ id: "edit_article_form", for: article });
    form.render();
  }
}

export default Form;
