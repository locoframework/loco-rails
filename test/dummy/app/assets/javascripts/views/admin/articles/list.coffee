class App.Views.Admin.Articles.List extends App.Views.Base
  constructor: (opts = {}) ->
    super opts

  render: (opts) ->
    for article in opts.articles
      $('#articles').append this._articleForListTemplate(article)

  renderNewArticle: (article) ->
    $('#articles').prepend this._articleForListTemplate(article)

  updateArticle: (articleId) ->
    return if $("#article_#{articleId}").length is 0
    App.Models.Article.find(id: articleId).then (article) =>
      $("#article_#{article.id}").replaceWith this._articleForListTemplate(article)

  commentsQuantityChangedForArticle: (articleId, quantity) ->
    return if $("#article_#{articleId}").length is 0
    sel = $("#article_#{articleId} span.comments_quantity")
    match = /\d+/.exec sel.text()
    quantity = parseInt(match[0]) + quantity
    sel.text "#{quantity} comment#{if quantity is 1 then '' else 's'}"

  _articleForListTemplate: (article) ->
    JST["templates/admin/articles/article_for_list"] article: article