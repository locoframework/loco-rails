import React from "react";
import { createRoot } from "react-dom/client";

import store from "store";

import { inlineList, inlineOne } from "utils/inline";
import Article from "models/Article";
import Comment from "models/article/Comment";
import EditView from "views/admin/articles/Edit";
import renderForm from "views/admin/articles/Form";

import ArticleList from "containers/admin/ArticleList";

const renderArticle = () => {
  const article = inlineOne("article-data", Article);
  EditView.render(article);
  renderForm(article);
};

const renderComment = () => {
  EditView.renderComments(inlineList("comments-data", Comment));
};

class Articles {
  published() {
    const articles = inlineList("articles-data", Article);
    store.dispatch({ type: "ARTICLES.SET", articles });
    createRoot(document.getElementById("articles")).render(
      <ArticleList articles={articles} />,
    );
  }

  edit() {
    renderArticle();
    renderComment();
  }
}

export default Articles;
