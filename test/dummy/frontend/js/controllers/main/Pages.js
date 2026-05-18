import React from "react";
import { createRoot } from "react-dom/client";

import store from "store";

import Article from "models/Article";
import LoadMoreLink from "containers/main/pages/LoadMoreLink";
import ArticleList from "containers/main/pages/ArticleList";

class Pages {
  async index() {
    createRoot(document.getElementById("load_more_wrapper")).render(
      <LoadMoreLink />,
    );
    const resp = await Article.get("all", { page: 1 });
    store.dispatch({ type: "SET_ARTICLES", articles: resp.resources });
    createRoot(document.getElementById("articles")).render(
      <ArticleList articles={resp.resources} />,
    );
  }
}

export default Pages;
