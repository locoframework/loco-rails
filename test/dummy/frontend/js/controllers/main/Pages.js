import React from "react";
import { createRoot } from "react-dom/client";

import { setArticles } from "actions";
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
    store.dispatch(setArticles(resp.resources));
    createRoot(document.getElementById("articles")).render(
      <ArticleList articles={resp.resources} />,
    );
  }
}

export default Pages;
