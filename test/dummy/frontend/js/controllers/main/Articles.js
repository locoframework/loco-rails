import { helpers } from "simplicit";

import store from "store";

import { inlineOne } from "utils/inline";

import Article from "models/Article";
import Comment from "models/article/Comment";
import ShowView from "views/main/articles/Show";

const renderArticle = () => {
  const article = inlineOne("article-data", Article);
  store.dispatch({ type: "ARTICLES.SET", articles: [article] });
  ShowView.renderArticle(article);
};

class Articles {
  show() {
    const newComment = new Comment({ articleId: helpers.params.id });
    ShowView.renderForm(newComment);
    renderArticle();
  }
}

export default Articles;
