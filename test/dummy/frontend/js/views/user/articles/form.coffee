class App.Views.User.Articles.Form extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @article = null
    @comments = null
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
    @comments = comments
    if comments.length is 0
      document.getElementById('comments').insertAdjacentHTML('beforeend', '<p id="no_comments">No comments.</p>')
      return
    noCommentNode = document.getElementById('no_comments')
    if noCommentNode
      noCommentNode.parentNode.removeChild(noCommentNode)
    this._renderComment comment for comment in comments
    this._handleApprovingComment()

  receivedSignal: (signal, data) ->
    switch signal
      when "updating"
        if document.querySelector('h1').getAttribute('data-mark') isnt data.mark
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
        commentNode = document.getElementById("comment_#{data.id}")
        commentNode.parentNode.removeChild(commentNode)

  _renderComment: (comment) ->
    template = JST["templates/user/comments/comment"] {comment: comment, isAdmin: true}
    commentNode = document.getElementById("comment_#{comment.id}")
    if commentNode
      commentNode.outerHTML = template
    else
      document.getElementById('comments').insertAdjacentHTML('beforeend', template)

  _displayChanges: ->
    for attrib, changes of @changes
      sel = document.querySelector("a.apply_changes[data-for=#{@article.getAttrRemoteName(attrib)}]")
      continue unless sel
      sel.classList.remove('none')

  _handleApplyingChanges: ->
    for sel in document.querySelectorAll('a.apply_changes')
      sel.addEventListener 'click', (e) =>
        e.preventDefault()
        attrName = @article.getAttrName(e.target.getAttribute('data-for'))
        @article[attrName] = @changes[attrName].is
        @form.fill attrName
        e.target.classList.add('none')

  _handleApprovingComment: ->
    for el in document.querySelectorAll('a.approve')
      el.addEventListener 'click', (e) =>
        e.preventDefault()
        commentId = parseInt e.target.parentNode.getAttribute('data-id')
        commentToApprove = null
        for comment in @comments
          continue if comment.id isnt commentId
          commentToApprove = comment
          break
        commentToApprove.approved = true
        commentToApprove.updateAttribute 'approved'
        .then (res) ->
          document.getElementById("comment_#{res.id}").querySelector('a.approve').outerHTML = '<span>approved</span>'
