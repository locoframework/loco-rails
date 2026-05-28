import React from "react";
import { createRoot } from "react-dom/client";
import { helpers } from "simplicit";

import store from "store";

import renderFlash from "views/shared/Flash";
import ShowView from "views/user/articles/Show";
import FormView from "views/user/articles/Form";

import Article from "models/Article";
import Comment from "models/article/Comment";

import ArticleList from "containers/user/ArticleList";
import CommentList from "containers/user/CommentList";

const renderArticle = async () => {
  const article = await Article.find(helpers.params.id);
  store.dispatch({ type: "ARTICLES.SET", articles: [article] });
  ShowView(article);
};

const renderComments = async () => {
  const resp = await Comment.all({ articleId: helpers.params.id });
  store.dispatch({
    type: "COMMENTS.SET",
    comments: resp.resources,
    articleId: helpers.params.id,
  });
  createRoot(document.getElementById("comments")).render(
    <CommentList articleId={helpers.params.id} comments={resp.resources} />,
  );
};

const onArticleDestroyed = (res) => {
  if (res.success) renderFlash({ notice: res.notice });
  else renderFlash({ alert: res.alert });
};

class Articles {
  initialize() {
    this.unsubscribe = null;
  }

  deinitialize() {
    if (this.unsubscribe !== null) {
      this.unsubscribe();
      this.unsubscribe = null;
    }
  }

  index() {
    if (helpers.params.message === "deleted") {
      renderFlash({ alert: "Article has been deleted." });
    }
    const articles = JSON.parse(
      document.getElementById("articles-data").textContent,
    ).map((a) => new Article(a));
    store.dispatch({ type: "ARTICLES.SET", articles });
    createRoot(document.getElementById("article_list")).render(
      <ArticleList
        articles={articles}
        onArticleDestroyed={onArticleDestroyed}
      />,
    );
  }

  show() {
    renderArticle();
    renderComments();
  }

  new() {
    this.unsubscribe = FormView.render(new Article());
  }

  async edit() {
    FormView.renderComments(helpers.params.id);
    const article = await Article.find(helpers.params.id);
    this.unsubscribe = FormView.render(article);
  }
}

export default Articles;
