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
    $('#title').text @article.title
    $('#author').text @article.author
    $('#pub_date').text (new App.Services.Date @article.publishedAt).toString 'short'
    $('#text').empty().append (new App.Helpers.Text).simpleFormat @article.content

  renderComments: (comments) ->
    if comments.length is 0
      $("#comments").append '<p id="no_comments">No comments.</p>'
    else
      $("#no_comments").remove()
      for comment in comments
        @comments.push comment
        this.connectWith comment, receiver: "_commentReceivedSignal"
        $("#comments").append JST["templates/main/comments/comment"] {comment: comment}
    this._updateCommentsQuantity()

  _updateCommentsQuantity: ->
    text = "#{@comments.length} comment#{if @comments.length is 1 then '' else 's'}"
    $('#comments_count').text text

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
        comment.reload =>
          comment.applyChanges()
          $("#comment_#{comment.id}").replaceWith JST["templates/main/comments/comment"] {comment: comment}
      when 'destroyed'
        comment = App.Utils.Collection.find @comments, (c) -> c.id is data.id
        @comments.splice @comments.indexOf(comment), 1
        $("#comment_#{comment.id}").remove()
        this._updateCommentsQuantity()
      else
        console.log "App.Views.Main.Articles.Show#_commentReceivedSignal: #{signal}"