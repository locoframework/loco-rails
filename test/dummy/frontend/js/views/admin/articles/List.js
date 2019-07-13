import { Views } from "loco-js";
import React from "react";
import { render as renderElement } from "react-dom";

import ArticleList from "components/admin/ArticleList";

class List extends Views.Base {
  constructor(opts = {}) {
    super(opts);
  }

  render({ articles }) {
    renderElement(
      <ArticleList articles={articles} />,
      document.getElementById("articles")
    );
    //for article in opts.articles
    //  renderedArticle = this._articleForListTemplate(article)
    //  document.getElementById('articles').insertAdjacentHTML('beforeend', renderedArticle)
  }

  //renderNewArticle: (article) ->
  //  renderedArticle = this._articleForListTemplate(article)
  //  document.getElementById('articles').insertAdjacentHTML('afterbegin', renderedArticle)
  //
  //updateArticle: (articleId) ->
  //  return unless document.getElementById("article_#{articleId}")
  //  App.Models.Article.find(id: articleId).then (article) =>
  //    document.getElementById("article_#{articleId}").outerHTML = this._articleForListTemplate(article)
  //
  //commentsQuantityChangedForArticle: (articleId, quantity) ->
  //  return unless document.getElementById("article_#{articleId}")
  //  sel = document.querySelector("#article_#{articleId} span.comments_quantity")
  //  match = /\d+/.exec(sel.textContent)
  //  quantity = parseInt(match[0]) + quantity
  //  sel.textContent = "#{quantity} comment#{if quantity is 1 then '' else 's'}"
  //
  //_articleForListTemplate: (article) ->
  //  JST["templates/admin/articles/article_for_list"] article: article
}

export default List;
