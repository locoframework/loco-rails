import React from "react";
import { render as renderElement } from "react-dom";
import { Views } from "loco-js";

import CommentList from "components/admin/CommentList";

class Edit extends Views.Base {
  constructor(opts = {}) {
    super(opts);
    this.article = null;
  }

  async receivedSignal(signal) {
    switch (signal) {
      case "updated":
        await this.article.reload();
        this.article.applyChanges();
        this._renderArticle();
    }
  }

  render(article) {
    this.article = article;
    this.connectWith(article);
    this._renderArticle();
  }

  renderComments(comments) {
    renderElement(
      <CommentList comments={comments} />,
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
