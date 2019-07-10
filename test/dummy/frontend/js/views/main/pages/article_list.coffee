import React from "react";
import { render as renderElement } from "react-dom";
import { Views } from "loco-js"

import Article from "models/article.coffee"
import Comment from "models/article/comment.coffee"
import ArticleListWrapper from "containers/ArticleListWrapper"

class ArticleList extends Views.Base
  constructor: (opts = {}) ->
    super opts
    @page = 1

  receivedSignal: (signal, data) ->
    switch signal
      when 'Article updated'
        this._updateArticle data.id
      when 'Article.Comment created'
        this._commentsQuantityChangedForArticle data.article_id, 1
      when 'Article.Comment destroyed'
        this._commentsQuantityChangedForArticle data.article_id, -1

  render: ->
    this._handleLoadMore()
    this.connectWith [Article, Comment]
    Article.get('all', page: 1).then (resp) => this._renderArticles resp.resources

  _renderArticles: (articles) ->
    # TODO: document.getElementById('articles').insertAdjacentHTML('beforeend', this._renderedArticle(article))
    renderElement(
      React.createElement(ArticleListWrapper, { articles: articles }),
      document.getElementById('articles')
    )

  _updateArticle: (articleId) ->
    return unless document.getElementById("article_#{articleId}")
    Article.find(id: articleId, abbr: true).then (article) =>
      document.getElementById("article_#{article.id}").outerHTML = this._renderedArticle(article)

  _commentsQuantityChangedForArticle: (articleId, quantity) ->
    return unless document.getElementById("article_#{articleId}")
    sel = document.querySelector("#article_#{articleId} a.comments_quantity")
    match = /\d+/.exec(sel.textContent)
    quantity = parseInt(match[0]) + quantity
    sel.textContent = "#{quantity} comment#{if quantity is 1 then '' else 's'}"

  _handleLoadMore: ->
    document.getElementById('load_more').addEventListener 'click', (e) =>
      e.preventDefault()
      @page += 1
      Article.get 'all', page: @page
      .then (resp) =>
        if resp.resources.length > 0
          this._renderArticles resp.resources
        else
          document.getElementById('load_more').outerHTML = '<p>No more posts.</p>'
      .catch (err) -> alert "Invalid URL"

  _renderedArticle: (article) ->
    JST["templates/main/articles/article_for_list"] {article: article}

export default ArticleList
