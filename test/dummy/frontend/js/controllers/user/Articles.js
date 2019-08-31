import React from "react";
import { render } from "react-dom";
import { Controllers } from "loco-js";

import { setArticles } from "actions/shared";
import store from "stores/user";

import UserLayout from "views/layouts/User";
import FlashView from "views/shared/Flash";
import ShowView from "views/user/articles/Show";
import FormView from "views/user/articles/Form";

import Article from "models/Article";
import Comment from "models/article/Comment";

import ArticleList from "containers/user/ArticleList";
import CommentList from "containers/user/CommentList";

class Articles extends Controllers.Base {
  initialize() {
    this.layout = new UserLayout();
  }

  onArticleDestroyed(res) {
    const flash = new FlashView();
    if (res.success) flash.setNotice(res.notice);
    else flash.setAlert(res.alert);
    flash.render();
  }

  index() {
    if (this.params.message === "deleted") {
      const flash = new FlashView({ alert: "Article has been deleted." });
      flash.render();
    }
    Article.get("all").then(resp => {
      store.dispatch(setArticles(resp.resources));
      render(
        <ArticleList
          articles={resp.resources}
          onArticleDestroyed={this.onArticleDestroyed}
        />,
        document.getElementById("article_list")
      );
    });
  }

  show() {
    this.showView = new ShowView();
    Article.find(this.params.id).then(article => {
      store.dispatch(setArticles([article]));
      this.showView.renderArticle(article);
    });
    Comment.all({ articleId: this.params.id }).then(resp => {
      store.dispatch({
        type: "SET_COMMENTS",
        payload: { articleId: this.params.id, comments: resp.resources }
      });
      render(
        <CommentList articleId={this.params.id} comments={resp.resources} />,
        document.getElementById("comments")
      );
    });
  }

  new() {
    new FormView().render(new Article());
  }

  edit() {
    const view = new FormView();
    Article.find(this.params.id).then(article => view.render(article));
    view.renderComments(this.params.id);
  }
}

export default Articles;
