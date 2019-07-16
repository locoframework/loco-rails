import React from "react";
import { render as renderElement } from "react-dom";
import { Helpers, Services, UI, Views } from "loco-js";

import Flash from "views/shared/flash.coffee";

import CommentList from "containers/main/articles/StatefulCommentList";

class Show extends Views.Base
  constructor: (opts = {}) ->
    super opts
    @article = null
    @comments = []
    @newComment = opts.comment

  render: ->
    form = new UI.Form for: @newComment, initObj: true, id: "new_comment"
    form.render()

  renderArticle: (article = null) ->
    if not @article?
      @article = article
      this.connectWith @article, receiver: "_articleReceivedSignal"
    document.getElementById("title").textContent = @article.title
    document.getElementById("author").textContent = @article.author
    dateService = new Services.Date @article.publishedAt
    document.getElementById("pub_date").textContent = dateService.toString 'short'
    textEl = document.getElementById "text"
    textEl.innerHTML = ""
    text = (new Helpers.Text).simpleFormat @article.content
    textEl.insertAdjacentHTML "beforeend", text

  renderComments: (comments) ->
    for comment in comments
      @comments.push comment
      this.connectWith comment, receiver: "_commentReceivedSignal"
    renderElement(
      React.createElement(CommentList, { comments }),
      document.getElementById('comments')
    )
    this._updateCommentsQuantity()

  _updateCommentsQuantity: ->
    text = "#{@comments.length} comment#{if @comments.length is 1 then '' else 's'}"
    document.getElementById('comments_count').textContent = text

  _articleReceivedSignal: (signal, data) ->
    switch signal
      when 'updating'
        txt = 'Author is currently editing article. Be aware of possible changes.'
        flash = new Flash warning: txt
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

export default Show