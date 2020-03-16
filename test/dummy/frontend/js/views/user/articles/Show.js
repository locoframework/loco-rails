import { subscribe, Views } from "loco-js";

import FlashView from "views/shared/Flash";

const updateEditLink = id => {
  const href = document.getElementById("edit_link").getAttribute("href");
  document
    .getElementById("edit_link")
    .setAttribute("href", href.replace("/0/", `/${id}/`));
};

const handlePublishing = article => {
  document
    .getElementById("publish_article")
    .addEventListener("click", async e => {
      e.preventDefault();
      e.target.textContent = "Publishing...";
      try {
        await article.put("publish");
        document.getElementById("publish_article").outerHTML =
          "<span>Published!</span>";
      } catch (err) {
        document.getElementById("publish_article").textContent = "Publish";
        const flash = new FlashView({ alert: "Connection error!" });
        flash.render();
      }
    });
};

const renderArticle = article => {
  document.getElementById("article_title").textContent = article.title;
  document.getElementById("article_text").textContent = article.content;
  const node = document.getElementById("publish_article");
  if (node && article.publishedAt != null) node.style.display = "none";
  else if (node) node.style.display = "";
};

const createArticleReceivedSignal = article => {
  return async function(signal) {
    switch (signal) {
      case "updated":
        await article.reload();
        article.applyChanges();
        renderArticle(article);
        break;
      case "destroyed":
        window.location.href = "/user/articles?message=deleted";
    }
  };
};

class Show extends Views.Base {
  constructor(opts = {}) {
    super(opts);
    this.article = null;
  }

  render(article = null) {
    if (this.article === null) {
      this.article = article;
      subscribe({ to: article, with: createArticleReceivedSignal(article) });
      handlePublishing(article);
      updateEditLink(article.id);
    }
    renderArticle(this.article);
  }
}

export default Show;
