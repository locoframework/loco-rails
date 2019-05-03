class App.Controllers.User.Articles extends App.Controllers.Base
  initialize: ->
    @layout = new App.Views.Layouts.User

  index: ->
    if @params.message is 'deleted'
      flash = new App.Views.Shared.Flash alert: 'Article has been deleted.'
      flash.render()
    @listView = new App.Views.User.Articles.List articles: []
    this.connectWith [App.Models.Article, App.Models.Article.Comment]
    App.Models.Article.get("all").then (resp) => @listView.renderArticles resp.resources

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