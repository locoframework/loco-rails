class App.Controllers.Admin.Articles extends App.Controllers.Base
  published: ->
    @view = new App.Views.Admin.Articles.List
    this.connectWith [App.Models.Article, App.Models.Article.Comment]
    App.Models.Article.get('published').then (resp) =>
      @view.render articles: resp.resources

  edit: ->
    App.Models.Article.find(@params.id).then (article) ->
      view = new App.Views.Admin.Articles.Form
      view.render article

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