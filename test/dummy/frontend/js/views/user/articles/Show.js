import { subscribe } from "loco-js";

import renderFlash from "views/shared/Flash";

const updateEditLink = (id) => {
  const href = document.getElementById("edit_link").getAttribute("href");
  document
    .getElementById("edit_link")
    .setAttribute("href", href.replace("/0/", `/${id}/`));
};

const handlePublishing = (article) => {
  document
    .getElementById("publish_article")
    .addEventListener("click", async (e) => {
      e.preventDefault();
      e.target.textContent = "Publishing...";
      try {
        await article.put("publish");
        document.getElementById("publish_article").outerHTML =
          "<span>Published!</span>";
      } catch {
        document.getElementById("publish_article").textContent = "Publish";
        renderFlash({ alert: "Connection error!" });
      }
    });
};

const renderArticle = (article) => {
  document.getElementById("article_title").textContent = article.title;
  document.getElementById("article_text").textContent = article.content;
  const node = document.getElementById("publish_article");
  if (node && article.publishedAt != null) node.style.display = "none";
  else if (node) node.style.display = "";
};

const createArticleReceivedMessage = (article) => {
  return async function (type) {
    switch (type) {
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

export default (article) => {
  if (article === null) return;
  subscribe({ to: article, with: createArticleReceivedMessage(article) });
  handlePublishing(article);
  updateEditLink(article.id);
  renderArticle(article);
};
