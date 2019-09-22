import React from "react";
import { render } from "react-dom";
import { Controllers } from "loco-js";

import { setArticles, setComments } from "actions";
import store from "stores/main";

import CommentList from "containers/main/articles/CommentList";
import CommentsNumber from "containers/main/articles/CommentsNumber";

import Article from "models/Article";
import Comment from "models/article/Comment";
import Show from "views/main/articles/Show";

class Articles extends Controllers.Base {
  show() {
    const newComment = new Comment({ articleId: this.params.id });
    const view = new Show({ comment: newComment });
    view.render();
    Article.find(this.params.id).then(article => {
      store.dispatch(setArticles([article]));
      view.renderArticle(article);
    });
    Comment.get("count", { articleId: this.params.id }).then(res => {
      Comment.all({ articleId: this.params.id, total: res.total }).then(
        comments => {
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
      );
    });
  }
}

export default Articles;
