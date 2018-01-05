class App.Views.User.Articles.Form extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @article = null
    @form = null
    @changes = null

  render: (article = null) ->
    @article = article
    this.connectWith @article
    this.connectWith [App.Models.Article.Comment], receiver: 'receivedArticleCommentSignal'
    this._handleApplyingChanges()
    @form = new App.UI.Form for: @article
    @form.render()

  renderComments: (comments) ->
    if comments.length is 0
      $("#comments").append '<p id="no_comments">No comments.</p>'
      return
    $('#no_comments').remove()
    this._renderComment comment for comment in comments

  receivedSignal: (signal, data) ->
    switch signal
      when "updating"
        if $('h1').data('mark') isnt data.mark
          flash = new App.Views.Shared.Flash warning: 'Uuups someone else started editing this article.'
          flash.render()
      when "updated"
        @article.reload().then =>
          @changes = @article.changes()
          this._displayChanges()
      when "destroyed"
        window.location.href = "/user/articles?message=deleted"

  receivedArticleCommentSignal: (signal, data) ->
    return if not @article.id?
    return if data.article_id? and data.article_id isnt @article.id
    switch signal
      when 'Article.Comment created'
        App.Models.Article.Comment.find(articleId: data.article_id, id: data.id).then (comment) =>
          this.renderComments [comment]
      when 'Article.Comment updated'
        App.Models.Article.Comment.find(articleId: data.article_id, id: data.id).then (comment) =>
          this._renderComment comment
      when 'Article.Comment destroyed'
        $("#comment_#{data.id}").remove()

  _renderComment: (comment) ->
    template = JST["templates/user/comments/comment"] {comment: comment, isAdmin: true}
    if $("#comment_#{comment.id}").length is 1
      $("#comment_#{comment.id}").replaceWith template
    else
      $("#comments").append template

  _displayChanges: ->
    for attrib, changes of @changes
      sel = $("a.apply_changes[data-for=#{@article.getRemoteName(attrib)}]")
      continue if sel.length is 0
      sel.removeClass 'none'

  _handleApplyingChanges: ->
    $('a.apply_changes').click (e) =>
      e.preventDefault()
      attrName = @article.getAttrName $(e.target).data('for')
      @article[attrName] = @changes[attrName].is
      @form.fill attrName
      $(e.target).addClass 'none'