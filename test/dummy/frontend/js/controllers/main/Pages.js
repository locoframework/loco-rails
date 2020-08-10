import React from "react";
import { render as renderElement } from "react-dom";

import { setArticles } from "actions";
import store from "store";

import Article from "models/Article";
import LoadMoreLink from "containers/main/pages/LoadMoreLink";
import ArticleList from "containers/main/pages/ArticleList";

class Pages {
  async index() {
    renderElement(
      <LoadMoreLink />,
      document.getElementById("load_more_wrapper")
    );
    const resp = await Article.get("all", { page: 1 });
    store.dispatch(setArticles(resp.resources));
    renderElement(
      <ArticleList articles={resp.resources} />,
      document.getElementById("articles")
    );
  }
}

export default Pages;
