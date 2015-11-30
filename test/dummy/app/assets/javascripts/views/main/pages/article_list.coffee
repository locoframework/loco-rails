class App.Views.Main.Pages.ArticleList extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @page = 1

  render: ->
    this._handleLoadMore()

  renderArticles: (articles) ->
    for article in articles
      $('#articles').append JST["templates/main/articles/article_for_list"] {article: article}

  renderNewArticle: (article) ->
    $('#articles').prepend JST["templates/main/articles/article_for_list"] {article: article}

  updateArticle: (articleId) ->
    return if $("#article_#{articleId}").length is 0
    App.Models.Article.find(id: articleId, abbr: true).then (article) ->
      template = JST["templates/main/articles/article_for_list"] {article: article}
      $("#article_#{article.id}").replaceWith template

  commentsQuantityChangedForArticle: (articleId, quantity) ->
    return if $("#article_#{articleId}").length is 0
    sel = $("#article_#{articleId} a.comments_quantity")
    match = /\d+/.exec sel.text()
    quantity = parseInt(match[0]) + quantity
    sel.text "#{quantity} comment#{if quantity is 1 then '' else 's'}"

  _handleLoadMore: ->
    $('#load_more').click (e) =>
      e.preventDefault()
      @page += 1
      App.Models.Article.get('all', page: @page).then (resp) =>
        if resp.resources.length > 0
          this.renderArticles resp.resources
        else
          $('#load_more').replaceWith('<p>No more posts.</p>')