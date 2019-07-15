import React from "react";
import { render as renderElement } from "react-dom";
import { Views } from "loco-js";

import StatefulCommentList from "containers/admin/StatefulCommentList";

class Edit extends Views.Base {
  constructor(opts = {}) {
    super(opts);
    this.article = null;
  }

  receivedSignal(signal) {
    switch (signal) {
      case "updated":
        this.article.reload().then(() => {
          this.article.applyChanges();
          this._renderArticle();
        });
    }
  }

  render(article) {
    this.article = article;
    this.connectWith(article);
    this._renderArticle();
  }

  renderComments(comments) {
    renderElement(
      <StatefulCommentList comments={comments} />,
      document.getElementById("comments")
    );
  }

  _renderArticle() {
    document.getElementById("article_author").textContent = this.article.author;
    document.getElementById("article_title").textContent = this.article.title;
    document.getElementById("article_text").textContent = this.article.content;
  }
}

export default Edit;
