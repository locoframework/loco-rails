class App.Views.User.Articles.Show extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @article = null

  renderArticle: (article = null) ->
    if not @article?
      this.connectWith article, receiver: "articleReceivedSignal"
      @article = article
    document.getElementById('article_title').textContent = @article.title
    document.getElementById('article_text').textContent = @article.content
    if @article.publishedAt?
      document.getElementById('publish_article').style.display = 'none'
    else
      document.getElementById('publish_article').style.display = ''
    this._handlePublishing()
    this._updateEditLink()

  renderComments: (comments) ->
    if comments.length is 0
      document.getElementById('comments').insertAdjacentHTML('beforeend', '<p>No comments.</p>')
      return
    for comment in comments
      this.connectWith comment, receiver: "commentReceivedSignal"
      renderedComment = JST["templates/user/comments/comment"] {comment: comment, isAdmin: false}
      document.getElementById('comments').insertAdjacentHTML('beforeend', renderedComment)

  articleReceivedSignal: (signal, data) ->
    switch signal
      when "updated"
        @article.reload().then =>
          @article.applyChanges()
          this.renderArticle()
      when "destroyed"
        window.location.href = "/user/articles?message=deleted"

  commentReceivedSignal: (signal, data) ->
    switch signal
      when "updated"
        App.Models.Article.Comment.find(id: data.id, articleId: data.article_id).then (comment) ->
          template = JST["templates/user/comments/comment"] {comment: comment, isAdmin: false}
          document.getElementById("comment_#{comment.id}").outerHTML = template
      when "destroyed"
        commentNode = document.getElementById("comment_#{data.id}")
        commentNode.parentNode.removeChild(commentNode)

  _handlePublishing: ->
    document.getElementById('publish_article').addEventListener 'click', (e) =>
      e.preventDefault()
      e.target.textContent = 'Publishing...'
      @article.put("publish")
      .then (res) ->
        document.getElementById('publish_article').outerHTML = '<span>Published!</span>'
      .catch (err) ->
        e.target.textContent = 'Publish'
        flash = new App.Views.Shared.Flash alert: "Connection error!"
        flash.render()

  _updateEditLink: ->
    href = document.getElementById('edit_link').getAttribute('href')
    document.getElementById('edit_link').setAttribute('href', href.replace("/0/", "/#{@article.id}/"))