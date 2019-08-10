import React from "react";
import { render as renderElement } from "react-dom";
import { Controllers } from "loco-js";

import store from "stores/main";
import Article from "models/article.coffee";
import LoadMoreLink from "containers/main/pages/LoadMoreLink";
import ArticleList from "containers/main/pages/StatefulArticleList";

class Pages extends Controllers.Base {
  index() {
    renderElement(
      <LoadMoreLink />,
      document.getElementById("load_more_wrapper")
    );

    Article.get("all", { page: 1 }).then(resp => {
      store.dispatch({
        type: "SET_ARTICLES",
        payload: { articles: resp.resources }
      });
      renderElement(
        <ArticleList articles={resp.resources} />,
        document.getElementById("articles")
      );
    });
  }
}

export default Pages;
