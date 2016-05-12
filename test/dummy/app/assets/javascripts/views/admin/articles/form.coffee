class App.Views.Admin.Articles.Form extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @article = null

  render: (@article) ->
    this.connectWith @article
    this._renderArticle()
    this._renderForm()

  receivedSignal: (signal, data) ->
    switch signal
      when 'updated'
        @article.reload().then =>
          @article.applyChanges()
          this._renderArticle()

  _renderArticle: ->
    $("#article_author").text @article.author
    $("#article_title").text @article.title
    $("#article_text").text @article.content

  _renderForm: ->
    @article.setDefaultValuesForAdminReview()
    form = new App.UI.Form id: 'edit_article_form', for: @article
    form.render()