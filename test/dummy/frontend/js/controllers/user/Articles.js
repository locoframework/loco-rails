import React from "react";
import { render } from "react-dom";
import { helpers, Controllers } from "loco-js";

import { setArticles, setComments } from "actions";
import store from "store";

import FlashView from "views/shared/Flash";
import ShowView from "views/user/articles/Show";
import FormView from "views/user/articles/Form";

import Article from "models/Article";
import Comment from "models/article/Comment";

import ArticleList from "containers/user/ArticleList";
import CommentList from "containers/user/CommentList";

class Articles extends Controllers.Base {
  onArticleDestroyed(res) {
    const flash = new FlashView();
    if (res.success) flash.setNotice(res.notice);
    else flash.setAlert(res.alert);
    flash.render();
  }

  async index() {
    if (helpers.params.message === "deleted") {
      const flash = new FlashView({ alert: "Article has been deleted." });
      flash.render();
    }
    const resp = await Article.get("all");
    store.dispatch(setArticles(resp.resources));
    render(
      <ArticleList
        articles={resp.resources}
        onArticleDestroyed={this.onArticleDestroyed}
      />,
      document.getElementById("article_list")
    );
  }

  async show() {
    this._renderArticle();
    this._renderComments();
  }

  new() {
    new FormView().render(new Article());
  }

  async edit() {
    const view = new FormView();
    view.renderComments(helpers.params.id);
    const article = await Article.find(helpers.params.id);
    view.render(article);
  }

  async _renderArticle() {
    const article = await Article.find(helpers.params.id);
    store.dispatch(setArticles([article]));
    new ShowView().render(article);
  }

  async _renderComments() {
    const resp = await Comment.all({ articleId: helpers.params.id });
    store.dispatch(setComments(resp.resources, helpers.params.id));
    render(
      <CommentList articleId={helpers.params.id} comments={resp.resources} />,
      document.getElementById("comments")
    );
  }
}

export default Articles;
