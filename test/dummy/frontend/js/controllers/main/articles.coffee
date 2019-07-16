import React from "react";
import { render } from "react-dom";
import { Controllers } from "loco-js";

import store from "stores/main";
import CommentList from "containers/main/articles/StatefulCommentList";

import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";
import Show from "views/main/articles/show.coffee"

class Articles extends Controllers.Base
  show: ->
    newComment = new Comment articleId: @params.id
    @view = new Show comment: newComment
    @view.render()
    this.connectWith [Comment]
    Article.find(@params.id).then (article) =>
      @view.renderArticle article
    Comment.get("count", articleId: @params.id).then (res) =>
      Comment
        .all(articleId: @params.id, total: res.total)
        .then (comments) =>
          #@view.renderComments comments
          store.dispatch({ type: "SET_COMMENTS", payload: { comments } });
          render(
            React.createElement(CommentList, { comments }),
            document.getElementById('comments')
          )

  receivedSignal: (signal, data) ->
    switch signal
      when 'Article.Comment created'
        return if data.article_id isnt @params.id
        Comment.find(id: data.id, articleId: data.article_id)
        .then (comment) => @view.renderComments [comment]

export default Articles
