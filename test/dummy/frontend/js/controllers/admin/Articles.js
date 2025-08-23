import React from "react";
import { createRoot } from "react-dom/client";
import { helpers } from "loco-js-core";

import { setArticles } from "actions";
import store from "store";

import Article from "models/Article";
import Comment from "models/article/Comment";
import EditView from "views/admin/articles/Edit";
import renderForm from "views/admin/articles/Form";

import ArticleList from "containers/admin/ArticleList";

const renderArticle = async () => {
  const article = await Article.find(helpers.params.id);
  EditView.render(article);
  renderForm(article);
};

const renderComment = async () => {
  const resp = await Comment.all({ articleId: helpers.params.id });
  EditView.renderComments(resp.resources);
};

class Articles {
  async published() {
    const resp = await Article.get("published");
    store.dispatch(setArticles(resp.resources));
    createRoot(document.getElementById("articles")).render(
      <ArticleList articles={resp.resources} />,
    );
  }

  async edit() {
    renderArticle();
    renderComment();
  }
}

export default Articles;
