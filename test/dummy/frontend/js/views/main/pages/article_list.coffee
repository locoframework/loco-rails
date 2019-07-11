import React from "react";
import { render as renderElement } from "react-dom";
import { Views } from "loco-js"

import store from "stores/main"
import Article from "models/article.coffee"
import Comment from "models/article/comment.coffee"
import LoadMoreLink from "containers/main/pages/LoadMoreLink"
import ArticleListWrapper from "containers/main/pages/ArticleListWrapper"

class ArticleList extends Views.Base
  constructor: (opts = {}) ->
    super opts

  receivedSignal: (signal, data) ->
    switch signal
      when 'Article.Comment created'
        this._commentsQuantityChangedForArticle data.article_id, 1
      when 'Article.Comment destroyed'
        this._commentsQuantityChangedForArticle data.article_id, -1

  render: ->
    renderElement(
      React.createElement(LoadMoreLink),
      document.getElementById('load_more_wrapper')
    )
    Article.get('all', page: 1).then (resp) =>
      store.dispatch({ type: "SET", payload: { articles: resp.resources } })
      renderElement(
        React.createElement(ArticleListWrapper, { articles: resp.resources }),
        document.getElementById('articles')
      )

  _commentsQuantityChangedForArticle: (articleId, quantity) ->
    return unless document.getElementById("article_#{articleId}")
    sel = document.querySelector("#article_#{articleId} a.comments_quantity")
    match = /\d+/.exec(sel.textContent)
    quantity = parseInt(match[0]) + quantity
    sel.textContent = "#{quantity} comment#{if quantity is 1 then '' else 's'}"

export default ArticleList
