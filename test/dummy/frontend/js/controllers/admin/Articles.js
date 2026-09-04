import { inlineList, inlineOne } from "utils/inline";
import Article from "models/Article";
import Comment from "models/article/Comment";
import EditView from "views/admin/articles/Edit";
import renderForm from "views/admin/articles/Form";

const renderArticle = () => {
  const article = inlineOne("article-data", Article);
  EditView.render(article);
  renderForm(article);
};

const renderComment = () => {
  EditView.renderComments(inlineList("comments-data", Comment));
};

class Articles {
  edit() {
    renderArticle();
    renderComment();
  }
}

export default Articles;
