class App.Views.Admin.Articles.Edit extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @article = null

  render: (@article) ->
    this.connectWith @article
    this._renderArticle()

  renderComments: (comments) ->
    if comments.length is 0
      $("#comments").append '<p>No comments.</p>'
      return
    for comment in comments
      $("#comments").append JST["templates/admin/comments/comment"] {comment: comment}

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