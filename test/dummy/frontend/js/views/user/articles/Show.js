import { Views } from "loco-js";

import FlashView from "views/shared/Flash";

class Show extends Views.Base {
  constructor(opts = {}) {
    super(opts);
    this.article = null;
  }

  renderArticle(article = null) {
    if (this.article != null) {
      this.connectWith(article, { receiver: "articleReceivedSignal" });
      this.article = article;
    }
    document.getElementById("article_title").textContent = this.article.title;
    document.getElementById("article_text").textContent = this.article.content;
    const node = document.getElementById("publish_article");
    if (node && this.article.publishedAt != null) node.style.display = "none";
    else if (node) node.style.display = "";
    this._handlePublishing();
    this._updateEditLink();
  }

  articleReceivedSignal(signal) {
    switch (signal) {
      case "updated":
        this.article.reload().then(() => {
          this.article.applyChanges();
          this.renderArticle();
        });
        break;
      case "destroyed":
        window.location.href = "/user/articles?message=deleted";
    }
  }

  _handlePublishing() {
    document.getElementById("publish_article").addEventListener("click", e => {
      e.preventDefault();
      e.target.textContent = "Publishing...";
      this.article
        .put("publish")
        .then(
          () =>
            (document.getElementById("publish_article").outerHTML =
              "<span>Published!</span>")
        )
        .catch(() => {
          e.target.textContent = "Publish";
          const flash = new FlashView({ alert: "Connection error!" });
          flash.render();
        });
    });
  }

  _updateEditLink() {
    const href = document.getElementById("edit_link").getAttribute("href");
    document
      .getElementById("edit_link")
      .setAttribute("href", href.replace("/0/", `/${this.article.id}/`));
  }
}

export default Show;
