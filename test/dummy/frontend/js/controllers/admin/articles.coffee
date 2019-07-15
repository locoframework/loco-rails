import { Controllers } from "loco-js";

import store from "stores/admin";
import Article from "models/article.coffee";
import Comment from "models/article/comment.coffee";
import List from "views/admin/articles/List";
import Edit from "views/admin/articles/Edit";
import Form from "views/admin/articles/Form";

class Articles extends Controllers.Base
  published: ->
    @view = new List
    #this.connectWith([Article, Comment]);
    Article.get('published').then (resp) =>
      store.dispatch({ type: "SET_ARTICLES", payload: { articles: resp.resources } });
      @view.render articles: resp.resources

  edit: ->
    editView = new Edit
    Article.find(this.params.id).then (article) ->
      editView.render(article)
      formView = new Form
      formView.render(article)
    Comment.all(articleId: this.params.id).then (resp) ->
      editView.renderComments(resp.resources)

  receivedSignal: (signal, data) ->
    switch signal
      when 'Article.Comment created'
        @view.commentsQuantityChangedForArticle data.article_id, 1
      when 'Article.Comment destroyed'
        @view.commentsQuantityChangedForArticle data.article_id, -1

export default Articles;
