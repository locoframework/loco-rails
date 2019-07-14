import { Views } from "loco-js";
import React from "react";
import { render as renderElement } from "react-dom";

import ArticleListWrapper from "containers/admin/ArticleListWrapper";

class List extends Views.Base {
  constructor(opts = {}) {
    super(opts);
  }

  render({ articles }) {
    renderElement(
      <ArticleListWrapper articles={articles} />,
      document.getElementById("articles")
    );
  }

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
