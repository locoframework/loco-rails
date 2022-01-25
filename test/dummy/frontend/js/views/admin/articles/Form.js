import { UI } from "loco-js-ui";

export default (article) => {
  article.setDefaultValuesForAdminReview();
  const form = new UI.Form({ id: "edit_article_form", for: article });
  form.render();
};
