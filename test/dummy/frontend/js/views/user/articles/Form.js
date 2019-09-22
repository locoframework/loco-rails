import React from "react";
import { render as renderElement } from "react-dom";
import { UI, Views } from "loco-js";

import { addArticles, setComments } from "actions";
import store from "stores/user";

import Comment from "models/article/Comment";

import FlashView from "views/shared/Flash";

import CommentList from "containers/user/CommentList";

class Form extends Views.Base {
  constructor(opts = {}) {
    super(opts);
    this.article = null;
    this.form = null;
    this.changes = null;
  }

  render(article) {
    store.dispatch(addArticles([article]));
    this.article = article;
    this.connectWith(this.article);
    this._handleApplyingChanges();
    this.form = new UI.Form({ for: this.article });
    this.form.render();
  }

  renderComments(articleId) {
    Comment.all({ articleId: articleId }).then(resp => {
      store.dispatch(setComments(resp.resources, articleId));
      renderElement(
        <CommentList
          articleId={articleId}
          comments={resp.resources}
          isAdmin={true}
        />,
        document.getElementById("comments")
      );
    });
  }

  receivedSignal(signal, data) {
    switch (signal) {
      case "updating":
        if (
          document.querySelector("h1").getAttribute("data-mark") !== data.mark
        ) {
          const flash = new FlashView({
            warning: "Uuups someone else started editing this article."
          });
          flash.render();
        }
        break;
      case "updated":
        this.article.reload().then(() => {
          this.changes = this.article.changes();
          this._displayChanges();
        });
        break;
      case "destroyed":
        window.location.href = "/user/articles?message=deleted";
    }
  }

  _displayChanges() {
    for (const [attrib] of Object.entries(this.changes)) {
      const sel = document.querySelector(
        `a.apply_changes[data-for=${this.article.getAttrRemoteName(attrib)}]`
      );
      if (!sel) continue;
      sel.classList.remove("none");
    }
  }

  _handleApplyingChanges() {
    for (const sel of Array.from(
      document.querySelectorAll("a.apply_changes")
    )) {
      sel.addEventListener("click", e => {
        e.preventDefault();
        const attrName = this.article.getAttrName(
          e.target.getAttribute("data-for")
        );
        this.article[attrName] = this.changes[attrName].is;
        this.form.fill(attrName);
        e.target.classList.add("none");
      });
    }
  }
}

export default Form;
