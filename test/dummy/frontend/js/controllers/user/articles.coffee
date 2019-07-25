import React from "react";
import { render } from "react-dom";
import { Controllers } from "loco-js"

import store from "stores/user";

import UserLayout from "views/layouts/user.coffee";
import FlashView from "views/shared/flash.coffee";
import ShowView from "views/user/articles/show.coffee";
import FormView from "views/user/articles/form.coffee";

import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";

import ArticleList from "containers/user/ArticleList";
import CommentList from "containers/user/CommentList";

class Articles extends Controllers.Base
  initialize: ->
    this.layout = new UserLayout

  onArticleDestroyed: (res) ->
    flash = new FlashView
    if res.success
      flash.setNotice res.notice
    else
      flash.setAlert res.alert
    flash.render()

  index: ->
    if this.params.message is 'deleted'
      flash = new FlashView alert: 'Article has been deleted.'
      flash.render()
    Article.get("all").then (resp) =>
      store.dispatch({
        type: "SET_ARTICLES",
        payload: { articles: resp.resources }
      });
      render(
        React.createElement(ArticleList, {
          articles: resp.resources,
          onArticleDestroyed: this.onArticleDestroyed
        }),
        document.getElementById("article_list");
      );

  show: ->
    this.showView = new ShowView
    Article.find(this.params.id).then (article) =>
      store.dispatch({
        type: "SET_ARTICLES",
        payload: { articles: [article] }
      });
      this.showView.renderArticle(article)
    Comment.all(articleId: this.params.id).then (resp) =>
      store.dispatch({
        type: "SET_COMMENTS",
        payload: { articleId: this.params.id, comments: resp.resources }
      });
      render(
        React.createElement(CommentList, {
          articleId: this.params.id,
          comments: resp.resources
        }),
        document.getElementById("comments");
      );

  new: ->
    view = new FormView;
    view.render(new Article);

  edit: ->
    view = new FormView;
    Article.find(this.params.id).then (article) -> view.render article
    view.renderComments(this.params.id)

export default Articles
