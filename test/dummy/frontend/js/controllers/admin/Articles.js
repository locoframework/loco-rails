import React from "react";
import { render } from "react-dom";
import { Controllers } from "loco-js";

import store from "stores/admin";
import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";
import Edit from "views/admin/articles/Edit";
import Form from "views/admin/articles/Form";

import ArticleListWrapper from "containers/admin/ArticleListWrapper";

class Articles extends Controllers.Base {
  published() {
    Article.get("published").then(resp => {
      store.dispatch({
        type: "SET_ARTICLES",
        payload: { articles: resp.resources }
      });
      render(
        <ArticleListWrapper articles={resp.resources} />,
        document.getElementById("articles")
      );
    });
  }

  edit() {
    const editView = new Edit();
    Article.find(this.params.id).then(article => {
      editView.render(article);
      new Form().render(article);
    });
    Comment.all({ articleId: this.params.id }).then(resp => {
      editView.renderComments(resp.resources);
    });
  }
}

export default Articles;
