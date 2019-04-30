class App.Views.Main.Pages.ArticleList extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @page = 1

  render: ->
    document.getElementById('articles').innerHTML = ''
    this._handleLoadMore()

  renderArticles: (articles) ->
    for article in articles
      document.getElementById('articles').insertAdjacentHTML('beforeend', this._renderedArticle(article))

  renderNewArticle: (article) ->
    document.getElementById('articles').insertAdjacentHTML('afterbegin', this._renderedArticle(article))

  updateArticle: (articleId) ->
    return unless document.getElementById("article_#{articleId}")
    App.Models.Article.find(id: articleId, abbr: true).then (article) =>
      document.getElementById("article_#{article.id}").outerHTML = this._renderedArticle(article)

  commentsQuantityChangedForArticle: (articleId, quantity) ->
    return unless document.getElementById("article_#{articleId}")
    sel = document.querySelector("#article_#{articleId} a.comments_quantity")
    match = /\d+/.exec(sel.textContent)
    quantity = parseInt(match[0]) + quantity
    sel.textContent = "#{quantity} comment#{if quantity is 1 then '' else 's'}"

  _handleLoadMore: ->
    loadMoreLink = document.getElementById('load_more')
    return unless loadMoreLink
    loadMoreLink.addEventListener 'click', (e) =>
      e.preventDefault()
      @page += 1
      App.Models.Article.get 'all', page: @page
      .then (resp) =>
        if resp.resources.length > 0
          this.renderArticles resp.resources
        else
          document.getElementById('load_more').outerHTML = '<p>No more posts.</p>'
      .catch (err) -> alert "Invalid URL"

  _renderedArticle: (article) ->
    JST["templates/main/articles/article_for_list"] {article: article}