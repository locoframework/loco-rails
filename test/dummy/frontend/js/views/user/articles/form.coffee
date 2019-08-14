import React from "react";
import { render as renderElement } from "react-dom";
import { UI, Views } from "loco-js";

import store from "stores/user";

import Comment from "models/article/Comment";

import FlashView from "views/shared/flash.coffee";

import CommentList from "containers/user/CommentList";

class Form extends Views.Base
  constructor: (opts = {}) ->
    super(opts);
    this.article = null;
    this.form = null;
    this.changes = null;

  render: (article) ->
    store.dispatch({
      type: "ADD_ARTICLES",
      payload: { articles: [article] }
    });
    this.article = article
    this.connectWith(this.article);
    this._handleApplyingChanges()
    this.form = new UI.Form for: @article
    this.form.render()

  renderComments: (articleId) ->
    Comment.all(articleId: articleId).then (resp) =>
      store.dispatch({
        type: "SET_COMMENTS",
        payload: { articleId: articleId, comments: resp.resources }
      });
      renderElement(
        React.createElement(CommentList, {
          articleId: articleId,
          comments: resp.resources,
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
          this.changes = @article.changes()
          this._displayChanges()
      when "destroyed"
        window.location.href = "/user/articles?message=deleted"

  _displayChanges: ->
    for attrib, changes of this.changes
      sel = document.querySelector("a.apply_changes[data-for=#{@article.getAttrRemoteName(attrib)}]")
      continue unless sel
      sel.classList.remove('none')

  _handleApplyingChanges: ->
    for sel in document.querySelectorAll('a.apply_changes')
      sel.addEventListener 'click', (e) =>
        e.preventDefault()
        attrName = @article.getAttrName(e.target.getAttribute('data-for'))
        @article[attrName] = this.changes[attrName].is
        this.form.fill attrName
        e.target.classList.add('none')

export default Form;
