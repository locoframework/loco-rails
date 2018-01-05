class App.Controllers.Main.Pages extends App.Controllers.Base
  index: ->
    @view = new App.Views.Main.Pages.ArticleList
    @view.render()
    this.connectWith [App.Models.Article, App.Models.Article.Comment]
    App.Models.Article.get('all', page: 1).then (resp) => @view.renderArticles resp.resources

  receivedSignal: (signal, data) ->
    switch signal
      when 'Article published'
        App.Models.Article.find(id: data.id, abbr: true).then (article) => @view.renderNewArticle article
      when 'Article updated'
        @view.updateArticle data.id
      when 'Article.Comment created'
        @view.commentsQuantityChangedForArticle data.article_id, 1
      when 'Article.Comment destroyed'
        @view.commentsQuantityChangedForArticle data.article_id, -1