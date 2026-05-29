import React from "react";
import { createRoot } from "react-dom/client";
import { helpers } from "simplicit";

import store from "store";

import { inlineList, inlineOne } from "utils/inline";
import CommentList from "containers/main/articles/CommentList";
import CommentsNumber from "containers/main/articles/CommentsNumber";

import Article from "models/Article";
import Comment from "models/article/Comment";
import ShowView from "views/main/articles/Show";

const renderArticle = () => {
  const article = inlineOne("article-data", Article);
  store.dispatch({ type: "ARTICLES.SET", articles: [article] });
  ShowView.renderArticle(article);
};

const renderComments = () => {
  const comments = inlineList("comments-data", Comment);
  store.dispatch({
    type: "COMMENTS.SET",
    comments,
    articleId: helpers.params.id,
  });
  createRoot(document.getElementById("comments")).render(
    <CommentList articleId={helpers.params.id} comments={comments} />,
  );
  createRoot(document.getElementById("comments_count")).render(
    <CommentsNumber articleId={helpers.params.id} comments={comments} />,
  );
};

class Articles {
  show() {
    const newComment = new Comment({ articleId: helpers.params.id });
    ShowView.renderForm(newComment);
    renderArticle();
    renderComments();
  }
}

export default Articles;
