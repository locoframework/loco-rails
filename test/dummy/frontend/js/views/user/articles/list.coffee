class App.Views.User.Articles.List extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @articles = opts.articles

  renderArticles: (articles) ->
    this.renderArticle article for article in articles

  renderArticle: (article) ->
    template = JST["templates/user/articles/article"] {article: article}
    articleNode = document.getElementById("article_#{article.id}")
    if articleNode
      articleNode.outerHTML = template
    else
      document.querySelector('table').insertAdjacentHTML('beforeend', template)
    this._handleDeletingArticle article

  deleteArticle: (articleId) ->
    articleNode = document.getElementById("article_#{article.id}")
    articleNode.parentNode.removeChild(articleNode)

  commentsQuantityChangedForArticle: (articleId, quantity) ->
    sel = document.querySelector("#article_#{articleId} td.comments_quantity")
    return unless sel
    match = /\d+/.exec(sel.textContent)
    quantity = parseInt(match[0]) + quantity
    sel.textContent = quantity

  _handleDeletingArticle: (article) ->
    document.querySelector("tr#article_#{article.id} a.delete_article").addEventListener 'click', (e) =>
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