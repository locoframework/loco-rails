import React from "react";
import { render } from "react-dom";
import { helpers, Controllers } from "loco-js";

import { setArticles, setComments } from "actions";
import store from "store";

import FlashView from "views/shared/Flash";
import ShowView from "views/user/articles/Show";
import FormView from "views/user/articles/Form";

import Article from "models/Article";
import Comment from "models/article/Comment";

import ArticleList from "containers/user/ArticleList";
import CommentList from "containers/user/CommentList";

const renderArticle = async () => {
  const article = await Article.find(helpers.params.id);
  store.dispatch(setArticles([article]));
  ShowView(article);
};

const renderComments = async () => {
  const resp = await Comment.all({ articleId: helpers.params.id });
  store.dispatch(setComments(resp.resources, helpers.params.id));
  render(
    <CommentList articleId={helpers.params.id} comments={resp.resources} />,
    document.getElementById("comments")
  );
};

const onArticleDestroyed = res => {
  const flash = new FlashView();
  if (res.success) flash.notice = res.notice;
  else flash.alert = res.alert;
  flash.render();
};

class Articles extends Controllers.Base {
  async index() {
    if (helpers.params.message === "deleted") {
      const flash = new FlashView({ alert: "Article has been deleted." });
      flash.render();
    }
    const resp = await Article.get("all");
    store.dispatch(setArticles(resp.resources));
    render(
      <ArticleList
        articles={resp.resources}
        onArticleDestroyed={onArticleDestroyed}
      />,
      document.getElementById("article_list")
    );
  }

  show() {
    renderArticle();
    renderComments();
  }

  new() {
    FormView.render(new Article());
  }

  async edit() {
    FormView.renderComments(helpers.params.id);
    const article = await Article.find(helpers.params.id);
    FormView.render(article);
  }
}

export default Articles;
