import React from "react";
import { createRoot } from "react-dom/client";
import { helpers } from "loco-js-core";

import { setArticles, setComments } from "actions";
import store from "store";

import CommentList from "containers/main/articles/CommentList";
import CommentsNumber from "containers/main/articles/CommentsNumber";

import Article from "models/Article";
import Comment from "models/article/Comment";
import ShowView from "views/main/articles/Show";

const renderArticle = async () => {
  const article = await Article.find(helpers.params.id);
  store.dispatch(setArticles([article]));
  ShowView.renderArticle(article);
};

const renderComments = async () => {
  const res = await Comment.get("count", { articleId: helpers.params.id });
  const comments = await Comment.all({
    articleId: helpers.params.id,
    total: res.total,
  });
  store.dispatch(setComments(comments, helpers.params.id));
  createRoot(document.getElementById("comments")).render(
    <CommentList articleId={helpers.params.id} comments={comments} />,
  );
  createRoot(document.getElementById("comments_count")).render(
    <CommentsNumber articleId={helpers.params.id} comments={comments} />,
  );
};

class Articles {
  async show() {
    const newComment = new Comment({ articleId: helpers.params.id });
    ShowView.renderForm(newComment);
    renderArticle();
    renderComments();
  }
}

export default Articles;
