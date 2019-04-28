class App.Views.Main.Articles.Show extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @article = null
    @comments = []
    @newComment = opts.comment

  render: ->
    form = new App.UI.Form for: @newComment, initObj: true, id: "new_comment"
    form.render()

  renderArticle: (article = null) ->
    if not @article?
      @article = article
      this.connectWith @article, receiver: "_articleReceivedSignal"
    document.getElementById("title").textContent = @article.title
    document.getElementById("author").textContent = @article.author
    dateService = new App.Services.Date @article.publishedAt
    document.getElementById("pub_date").textContent = dateService.toString 'short'
    textEl = document.getElementById "text"
    textEl.innerHTML = ""
    text = (new App.Helpers.Text).simpleFormat @article.content
    textEl.insertAdjacentHTML "beforeend", text

  renderComments: (comments) ->
    if comments.length is 0
      noCommentsHTML = '<p id="no_comments">No comments.</p>'
      document.getElementById('comments').insertAdjacentHTML('beforeend', noCommentsHTML)
    else
      noCommentsNode = document.getElementById('no_comments')
      if noCommentsNode
        noCommentsNode.parentNode.removeChild(noCommentsNode);
      for comment in comments
        @comments.push comment
        this.connectWith comment, receiver: "_commentReceivedSignal"
        renderedComment = JST["templates/main/comments/comment"] {comment: comment}
        document.getElementById('comments').insertAdjacentHTML('beforeend', renderedComment)
    this._updateCommentsQuantity()

  _updateCommentsQuantity: ->
    text = "#{@comments.length} comment#{if @comments.length is 1 then '' else 's'}"
    document.getElementById('comments_count').textContent = text

  _articleReceivedSignal: (signal, data) ->
    switch signal
      when 'updating'
        txt = 'Author is currently editing article. Be aware of possible changes.'
        flash = new App.Views.Shared.Flash warning: txt
        flash.render()
      when 'updated'
        @article.reload().then =>
          @article.applyChanges()
          this.renderArticle()
      else
        console.log "App.Views.Main.Articles.Show#_articleReceivedSignal: #{signal}"

  _commentReceivedSignal: (signal, data) ->
    switch signal
      when 'updated'
        comment = App.Utils.Collection.find @comments, (c) -> c.id is data.id
        comment.reload().then =>
          comment.applyChanges()
          renderedComment = JST["templates/main/comments/comment"] {comment: comment}
          document.getElementById("comment_#{comment.id}").outerHTML = renderedComment
      when 'destroyed'
        comment = App.Utils.Collection.find @comments, (c) -> c.id is data.id
        @comments.splice @comments.indexOf(comment), 1
        commentNode = document.getElementById("comment_#{comment.id}")
        commentNode.parentNode.removeChild(commentNode)
        this._updateCommentsQuantity()
      else
        console.log "App.Views.Main.Articles.Show#_commentReceivedSignal: #{signal}"