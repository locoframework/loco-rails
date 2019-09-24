import React from "react";
import { render } from "react-dom";
import { Controllers } from "loco-js";

import { setArticles, setComments } from "actions";
import store from "store";

import CommentList from "containers/main/articles/CommentList";
import CommentsNumber from "containers/main/articles/CommentsNumber";

import Article from "models/Article";
import Comment from "models/article/Comment";
import Show from "views/main/articles/Show";

class Articles extends Controllers.Base {
  async show() {
    const newComment = new Comment({ articleId: this.params.id });
    const view = new Show({ comment: newComment });
    view.render();
    this._renderArticle(view);
    this._renderComments();
  }

  async _renderArticle(view) {
    const article = await Article.find(this.params.id);
    store.dispatch(setArticles([article]));
    view.renderArticle(article);
  }

  async _renderComments() {
    const res = await Comment.get("count", { articleId: this.params.id });
    const comments = await Comment.all({
      articleId: this.params.id,
      total: res.total
    });
    store.dispatch(setComments(comments, this.params.id));
    render(
      <CommentList articleId={this.params.id} comments={comments} />,
      document.getElementById("comments")
    );
    render(
      <CommentsNumber articleId={this.params.id} comments={comments} />,
      document.getElementById("comments_count")
    );
  }
}

export default Articles;
