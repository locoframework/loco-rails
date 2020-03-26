import { UI } from "loco-js-ui";

class Form {
  render(article) {
    article.setDefaultValuesForAdminReview();
    const form = new UI.Form({ id: "edit_article_form", for: article });
    form.render();
  }
}

export default Form;
