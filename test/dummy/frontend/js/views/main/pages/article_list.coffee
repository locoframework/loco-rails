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

export default ArticleList
