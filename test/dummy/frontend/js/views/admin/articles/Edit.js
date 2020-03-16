import React from "react";
import { render as renderElement } from "react-dom";
import { subscribe, Views } from "loco-js";

import CommentList from "components/admin/CommentList";

let article = null;

const renderArticle = () => {
  document.getElementById("article_author").textContent = article.author;
  document.getElementById("article_title").textContent = article.title;
  document.getElementById("article_text").textContent = article.content;
};

const receivedSignal = async signal => {
  switch (signal) {
    case "updated":
      await article.reload();
      article.applyChanges();
      renderArticle();
  }
};

class Edit extends Views.Base {
  constructor(opts = {}) {
    super(opts);
  }

  render(anArticle) {
    article = anArticle;
    subscribe({ to: article, with: receivedSignal });
    renderArticle();
  }

  renderComments(comments) {
    renderElement(
      <CommentList comments={comments} />,
      document.getElementById("comments")
    );
  }
}

export default Edit;
