import { Controllers } from "loco-js";

import store from "stores/admin";
import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";
import List from "views/admin/articles/List";

class Articles extends Controllers.Base
  published: ->
    @view = new List
    #this.connectWith([Article, Comment]);
    Article.get('published').then (resp) =>
      store.dispatch({ type: "SET_ARTICLES", payload: { articles: resp.resources } });
      @view.render articles: resp.resources

  edit: ->
    editView = new App.Views.Admin.Articles.Edit
    App.Models.Article.find(@params.id).then (article) ->
      editView.render article
      formView = new App.Views.Admin.Articles.Form
      formView.render article
    App.Models.Article.Comment.all(articleId: @params.id).then (resp) ->
      editView.renderComments resp.resources

  receivedSignal: (signal, data) ->
    switch signal
      when 'Article updated'
        @view.updateArticle data.id
      when 'Article.Comment created'
        @view.commentsQuantityChangedForArticle data.article_id, 1
      when 'Article.Comment destroyed'
        @view.commentsQuantityChangedForArticle data.article_id, -1

export default Articles;
