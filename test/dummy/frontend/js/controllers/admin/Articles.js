import React from "react";
import { render } from "react-dom";
import { helpers, Controllers } from "loco-js";

import { setArticles } from "actions";
import store from "store";

import Article from "models/Article";
import Comment from "models/article/Comment";
import Edit from "views/admin/articles/Edit";
import Form from "views/admin/articles/Form";

import ArticleList from "containers/admin/ArticleList";

class Articles extends Controllers.Base {
  async published() {
    const resp = await Article.get("published");
    store.dispatch(setArticles(resp.resources));
    render(
      <ArticleList articles={resp.resources} />,
      document.getElementById("articles")
    );
  }

  async edit() {
    const editView = new Edit();
    this._renderArticle(editView);
    this._renderComment(editView);
  }

  async _renderArticle(view) {
    const article = await Article.find(helpers.params().id);
    view.render(article);
    new Form().render(article);
  }

  async _renderComment(view) {
    const resp = await Comment.all({ articleId: helpers.params().id });
    view.renderComments(resp.resources);
  }
}

export default Articles;
