class App.Views.Admin.Articles.Edit extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @article = null

  render: (@article) ->
    this.connectWith @article
    this._renderArticle()

  renderComments: (comments) ->
    if comments.length is 0
      document.getElementById('comments').insertAdjacentHTML('beforeend', '<p>No comments.</p>')
      return
    for comment in comments
      renderedComment = JST["templates/admin/comments/comment"] {comment: comment}
      document.getElementById('comments').insertAdjacentHTML('beforeend', renderedComment);

  receivedSignal: (signal, data) ->
    switch signal
      when 'updated'
        @article.reload().then =>
          @article.applyChanges()
          this._renderArticle()

  _renderArticle: ->
    document.getElementById('article_author').textContent = @article.author
    document.getElementById('article_title').textContent = @article.title
    document.getElementById('article_text').textContent = @article.content
