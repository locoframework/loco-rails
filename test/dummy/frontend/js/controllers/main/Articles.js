import React from "react";
import { render } from "react-dom";
import { helpers, Controllers } from "loco-js";

import { setArticles, setComments } from "actions";
import store from "store";

import CommentList from "containers/main/articles/CommentList";
import CommentsNumber from "containers/main/articles/CommentsNumber";

import Article from "models/Article";
import Comment from "models/article/Comment";
import Show, { renderArticle } from "views/main/articles/Show";

class Articles extends Controllers.Base {
  async show() {
    const newComment = new Comment({ articleId: helpers.params.id });
    const view = new Show({ comment: newComment });
    view.render();
    this._renderArticle();
    this._renderComments();
  }

  async _renderArticle() {
    const article = await Article.find(helpers.params.id);
    store.dispatch(setArticles([article]));
    renderArticle(article);
  }

  async _renderComments() {
    const res = await Comment.get("count", { articleId: helpers.params.id });
    const comments = await Comment.all({
      articleId: helpers.params.id,
      total: res.total
    });
    store.dispatch(setComments(comments, helpers.params.id));
    render(
      <CommentList articleId={helpers.params.id} comments={comments} />,
      document.getElementById("comments")
    );
    render(
      <CommentsNumber articleId={helpers.params.id} comments={comments} />,
      document.getElementById("comments_count")
    );
  }
}

export default Articles;
