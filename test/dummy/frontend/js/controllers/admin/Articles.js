import React from "react";
import { createRoot } from "react-dom/client";

import store from "store";

import Article from "models/Article";
import Comment from "models/article/Comment";
import EditView from "views/admin/articles/Edit";
import renderForm from "views/admin/articles/Form";

import ArticleList from "containers/admin/ArticleList";

const renderArticle = () => {
  const article = new Article(
    JSON.parse(document.getElementById("article-data").textContent),
  );
  EditView.render(article);
  renderForm(article);
};

const renderComment = () => {
  const comments = JSON.parse(
    document.getElementById("comments-data").textContent,
  ).map((c) => new Comment(c));
  EditView.renderComments(comments);
};

class Articles {
  published() {
    const articles = JSON.parse(
      document.getElementById("articles-data").textContent,
    ).map((a) => new Article(a));
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
