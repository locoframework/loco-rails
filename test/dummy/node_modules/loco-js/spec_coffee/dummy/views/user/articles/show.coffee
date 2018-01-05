class App.Views.User.Articles.Show extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @article = null

  renderArticle: (article = null) ->
    if not @article?
      this.connectWith article, receiver: "articleReceivedSignal"
      @article = article
    $("#article_title").text @article.title
    $("#article_text").text @article.content
    if @article.publishedAt?
      $("#publish_article").hide()
    else
      $("#publish_article").show()
    this._handlePublishing()
    this._updateEditLink()

  renderComments: (comments) ->
    if comments.length is 0
      $("#comments").append '<p>No comments.</p>'
      return
    for comment in comments
      this.connectWith comment, receiver: "commentReceivedSignal"
      $("#comments").append JST["templates/user/comments/comment"] {comment: comment, isAdmin: false}

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
          $("#comment_#{comment.id}").replaceWith template
      when "destroyed"
        $("#comment_#{data.id}").remove()

  _handlePublishing: ->
    $("a#publish_article").click (e) =>
      e.preventDefault()
      $(e.target).text "Publishing..."
      @article.put("publish")
      .then (res) ->
        $("a#publish_article").replaceWith "<span>Published!</span>"
      .catch (err) ->
        $(e.target).text "Publish"
        flash = new App.Views.Shared.Flash alert: "Connection error!"
        flash.render()

  _updateEditLink: ->
    href = $("#edit_link").attr "href"
    $("#edit_link").attr "href", href.replace "/0/", "/#{@article.id}/"