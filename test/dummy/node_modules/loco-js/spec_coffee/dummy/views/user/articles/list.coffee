class App.Views.User.Articles.List extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @articles = opts.articles

  renderArticles: (articles) ->
    this.renderArticle article for article in articles

  renderArticle: (article) ->
    template = JST["templates/user/articles/article"] {article: article}
    if $("#article_#{article.id}").length is 1
      $("#article_#{article.id}").replaceWith template
    else
      $("table").append template
    this._handleDeletingArticle article

  deleteArticle: (articleId) ->
    $("#article_#{articleId}").remove()

  commentsQuantityChangedForArticle: (articleId, quantity) ->
    sel = $("#article_#{articleId} td.comments_quantity")
    return if sel.length is 0
    match = /\d+/.exec sel.text()
    quantity = parseInt(match[0]) + quantity
    sel.text quantity

  _handleDeletingArticle: (article) ->
    $("tr#article_#{article.id} a.delete_article").click (e) =>
      e.preventDefault()
      return if not confirm "Are you sure?"
      article.delete(null).then (data) =>
        flash = new App.Views.Shared.Flash
        if data.success
          this.deleteArticle data.id
          flash.setNotice data.notice
        else
          flash.setAlert data.alert
        flash.render()