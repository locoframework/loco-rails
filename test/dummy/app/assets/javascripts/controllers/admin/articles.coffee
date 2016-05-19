class App.Controllers.Admin.Articles extends App.Controllers.Base
  published: ->
    @view = new App.Views.Admin.Articles.List
    this.connectWith [App.Models.Article, App.Models.Article.Comment]
    App.Models.Article.get('published').then (resp) =>
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
      when 'Article published'
        App.Models.Article.find(id: data.id).then (article) =>
          @view.renderNewArticle article
      when 'Article updated'
        @view.updateArticle data.id
      when 'Article.Comment created'
        @view.commentsQuantityChangedForArticle data.article_id, 1
      when 'Article.Comment destroyed'
        @view.commentsQuantityChangedForArticle data.article_id, -1