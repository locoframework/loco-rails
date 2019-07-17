import React from "react";
import { render } from "react-dom";
import { Controllers } from "loco-js";

import store from "stores/main";
import CommentList from "containers/main/articles/StatefulCommentList";
import CommentsNumber from "containers/main/articles/CommentsNumber";

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
        .all(articleId: this.params.id, total: res.total)
        .then (comments) =>
          store.dispatch({ type: "SET_COMMENTS", payload: { articleId: this.params.id, comments } });
          render(
            React.createElement(CommentList, { articleId: this.params.id, comments }),
            document.getElementById('comments')
          )
          render(
            React.createElement(CommentsNumber, { articleId: this.params.id, comments }),
            document.getElementById('comments_count')
          )

export default Articles
