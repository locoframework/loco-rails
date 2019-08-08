import React from "react";
import { render as renderElement } from "react-dom";
import { UI, Views } from "loco-js";

import store from "stores/user";

import Comment from "models/article/comment.coffee";

import FlashView from "views/shared/flash.coffee";

import CommentList from "containers/user/CommentList";

class Form extends Views.Base
  constructor: (opts = {}) ->
    super opts
    this.article = null
    this.comments = null
    @form = null
    @changes = null

  render: (article) ->
    store.dispatch({
      type: "ADD_ARTICLES",
      payload: { articles: [article] }
    });
    this.article = article
    this.connectWith @article
    this.connectWith [Comment], receiver: 'receivedArticleCommentSignal'
    this._handleApplyingChanges()
    @form = new UI.Form for: @article
    @form.render()

  renderComments: (articleId) ->
    Comment.all(articleId: articleId).then (resp) =>
      this.comments = resp.resources
      store.dispatch({
        type: "SET_COMMENTS",
        payload: { articleId: articleId, comments: this.comments }
      });
      renderElement(
        React.createElement(CommentList, {
          articleId: articleId,
          comments: this.comments,
          isAdmin: true
        }),
        document.getElementById("comments");
      );

  receivedSignal: (signal, data) ->
    switch signal
      when "updating"
        if document.querySelector('h1').getAttribute('data-mark') isnt data.mark
          flash = new FlashView warning: 'Uuups someone else started editing this article.'
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
    #switch signal
    #  when 'Article.Comment destroyed'
    #    commentNode = document.getElementById("comment_#{data.id}")
    #    commentNode.parentNode.removeChild(commentNode)

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

export default Form;
