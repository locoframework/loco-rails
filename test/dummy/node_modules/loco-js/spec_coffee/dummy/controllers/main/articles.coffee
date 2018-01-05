class App.Controllers.Main.Articles extends App.Controllers.Base
  show: ->
    @view = new App.Views.Main.Articles.Show comment: new App.Models.Article.Comment articleId: @params.id
    @view.render()
    this.connectWith [App.Models.Article.Comment]
    App.Models.Article.find(@params.id).then (article) => @view.renderArticle article
    App.Models.Article.Comment.all(articleId: @params.id).then (resp) =>
      @view.renderComments resp.resources

  receivedSignal: (signal, data) ->
    switch signal
      when 'Article.Comment created'
        return if data.article_id isnt @params.id
        App.Models.Article.Comment.find(id: data.id, articleId: data.article_id)
        .then (comment) => @view.renderComments [comment]