import React from "react";
import { render } from "react-dom";
import { helpers } from "loco-js";

import { setArticles, setComments } from "actions";
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
  if (res.success) renderFlash({ notice: res.notice });
  else renderFlash({ alert: res.alert });
};

class Articles {
  async index() {
    if (helpers.params.message === "deleted") {
      renderFlash({ alert: "Article has been deleted." });
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
