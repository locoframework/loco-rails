class App.Views.Main.Pages.ArticleList extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @page = 1

  receivedSignal: (signal, data) ->
    switch signal
      when 'Article published'
        App.Models.Article.find(id: data.id, abbr: true).then (article) => this._renderNewArticle article
      when 'Article updated'
        this._updateArticle data.id
      when 'Article.Comment created'
        this._commentsQuantityChangedForArticle data.article_id, 1
      when 'Article.Comment destroyed'
        this._commentsQuantityChangedForArticle data.article_id, -1

  render: ->
    this._handleLoadMore()
    this.connectWith [App.Models.Article, App.Models.Article.Comment]
    App.Models.Article.get('all', page: 1).then (resp) => this._renderArticles resp.resources

  _renderArticles: (articles) ->
    for article in articles
      document.getElementById('articles').insertAdjacentHTML('beforeend', this._renderedArticle(article))

  _renderNewArticle: (article) ->
    document.getElementById('articles').insertAdjacentHTML('afterbegin', this._renderedArticle(article))

  _updateArticle: (articleId) ->
    return unless document.getElementById("article_#{articleId}")
    App.Models.Article.find(id: articleId, abbr: true).then (article) =>
      document.getElementById("article_#{article.id}").outerHTML = this._renderedArticle(article)

  _commentsQuantityChangedForArticle: (articleId, quantity) ->
    return unless document.getElementById("article_#{articleId}")
    sel = document.querySelector("#article_#{articleId} a.comments_quantity")
    match = /\d+/.exec(sel.textContent)
    quantity = parseInt(match[0]) + quantity
    sel.textContent = "#{quantity} comment#{if quantity is 1 then '' else 's'}"

  _handleLoadMore: ->
    document.getElementById('load_more').addEventListener 'click', (e) =>
      e.preventDefault()
      @page += 1
      App.Models.Article.get 'all', page: @page
      .then (resp) =>
        if resp.resources.length > 0
          this._renderArticles resp.resources
        else
          document.getElementById('load_more').outerHTML = '<p>No more posts.</p>'
      .catch (err) -> alert "Invalid URL"

  _renderedArticle: (article) ->
    JST["templates/main/articles/article_for_list"] {article: article}