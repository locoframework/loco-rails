import { Controllers } from "loco-js"

import UserLayout from "views/layouts/user.coffee";
import Flash from "views/shared/flash.coffee";
import List from "views/user/articles/list.coffee";

import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";

class Articles extends Controllers.Base
  initialize: ->
    this.layout = new UserLayout

  index: ->
    if this.params.message is 'deleted'
      flash = new Flash alert: 'Article has been deleted.'
      flash.render()
    this.listView = new List articles: []
    this.connectWith [Article, Comment];
    Article.get("all").then (resp) => this.listView.renderArticles resp.resources

  show: ->
    @showView = new App.Views.User.Articles.Show
    this.connectWith [App.Models.Article.Comment]
    App.Models.Article.find(@params.id).then (article) => @showView.renderArticle article
    App.Models.Article.Comment.all(articleId: @params.id).then (resp) =>
      @showView.renderComments resp.resources

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
      when "Article created"
        App.Models.Article.find(id: data.id, abbr: true).then (article) =>
          @listView.renderArticles [article]
      when "Article updated"
        App.Models.Article.find(id: data.id, abbr: true).then (article) =>
          @listView.renderArticle article
      when "Article destroyed"
        @listView.deleteArticle data.id
      when "Article.Comment created"
        return if @params.id? and data.article_id? and data.article_id isnt @params.id
        if @listView?
          @listView.commentsQuantityChangedForArticle data.article_id, 1
        else if @showView?
          App.Models.Article.Comment.find(articleId: data.article_id, id: data.id).then (comment) =>
            @showView.renderComments [comment]
      when "Article.Comment destroyed"
        if @listView?
          @listView.commentsQuantityChangedForArticle data.article_id, -1

export default Articles
