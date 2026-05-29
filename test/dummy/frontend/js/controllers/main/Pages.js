import React from "react";
import { createRoot } from "react-dom/client";

import store from "store";

import Article from "models/Article";
import LoadMoreLink from "containers/main/pages/LoadMoreLink";
import ArticleList from "containers/main/pages/ArticleList";

class Pages {
  index() {
    createRoot(document.getElementById("load_more_wrapper")).render(
      <LoadMoreLink />,
    );
    const articles = JSON.parse(
      document.getElementById("articles-data").textContent,
    ).map((a) => new Article(a));
    store.dispatch({ type: "ARTICLES.SET", articles });
    createRoot(document.getElementById("articles")).render(
      <ArticleList articles={articles} />,
    );
  }
}

export default Pages;
