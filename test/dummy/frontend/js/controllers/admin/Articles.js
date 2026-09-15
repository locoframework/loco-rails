import { inlineOne } from "utils/inline";
import Article from "models/Article";
import EditView from "views/admin/articles/Edit";
import renderForm from "views/admin/articles/Form";

const renderArticle = () => {
  const article = inlineOne("article-data", Article);
  EditView.render(article);
  renderForm(article);
};

class Articles {
  edit() {
    renderArticle();
  }
}

export default Articles;
