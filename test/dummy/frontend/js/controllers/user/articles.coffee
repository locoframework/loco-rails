import React from "react";
import { render } from "react-dom";
import { Controllers } from "loco-js"

import store from "stores/user";

import UserLayout from "views/layouts/user.coffee";
import Flash from "views/shared/flash.coffee";
import ShowView from "views/user/articles/show.coffee";

import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";

import ArticleList from "containers/user/ArticleList";

class Articles extends Controllers.Base
  initialize: ->
    this.layout = new UserLayout

  onArticleDestroyed: (res) ->
    flash = new Flash
    if res.success
      flash.setNotice res.notice
    else
      flash.setAlert res.alert
    flash.render()

  index: ->
    if this.params.message is 'deleted'
      flash = new Flash alert: 'Article has been deleted.'
      flash.render()
    this.connectWith [Article, Comment];
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
    this.connectWith([Comment]);
    Article.find(this.params.id).then (article) => this.showView.renderArticle(article)
    Comment.all(articleId: this.params.id).then (resp) =>
      store.dispatch({
        type: "SET_COMMENTS",
        payload: { articleId: this.params.id, comments: resp.resources }
      });
      this.showView.renderComments(resp.resources)

  new: ->
    view = new App.Views.User.Articles.Form
    view.render new App.Models.Article

  edit: ->
    view = new App.Views.User.Articles.Form
    App.Models.Article.find(@params.id).then (article) -> view.render article
    App.Models.Article.Comment.all(articleId: @params.id).then (resp) ->
      view.renderComments resp.resources

  receivedSignal: (signal, data) ->
    switch signal
      when "Article.Comment created"
        return if @params.id? and data.article_id? and data.article_id isnt @params.id
        if @showView?
          App.Models.Article.Comment.find(articleId: data.article_id, id: data.id).then (comment) =>
            @showView.renderComments [comment]

export default Articles
