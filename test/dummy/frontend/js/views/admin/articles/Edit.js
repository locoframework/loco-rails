import React from "react";
import { render as renderElement } from "react-dom";
import { subscribe } from "loco-js";

import CommentList from "components/admin/CommentList";

const renderArticle = article => {
  document.getElementById("article_author").textContent = article.author;
  document.getElementById("article_title").textContent = article.title;
  document.getElementById("article_text").textContent = article.content;
};

const createReceivedMessage = article => {
  return async function(type) {
    switch (type) {
      case "updated": {
        const reloadedArticle = await article.reload();
        renderArticle(reloadedArticle);
      }
    }
  };
};

export default {
  render: article => {
    subscribe({ to: article, with: createReceivedMessage(article) });
    renderArticle(article);
  },

  renderComments: comments => {
    renderElement(
      <CommentList comments={comments} />,
      document.getElementById("comments")
    );
  }
};
