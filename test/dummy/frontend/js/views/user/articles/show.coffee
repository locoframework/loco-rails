import { Views } from "loco-js";

import FlashView from "views/shared/Flash";

class Show extends Views.Base
  constructor: (opts = {}) ->
    super opts
    @article = null

  renderArticle: (article = null) ->
    if not @article?
      this.connectWith article, receiver: "articleReceivedSignal"
      @article = article
    document.getElementById('article_title').textContent = @article.title
    document.getElementById('article_text').textContent = @article.content
    node = document.getElementById('publish_article')
    if node and @article.publishedAt?
      node.style.display = 'none'
    else if node
      node.style.display = ''
    this._handlePublishing()
    this._updateEditLink()

  articleReceivedSignal: (signal, data) ->
    switch signal
      when "updated"
        @article.reload().then =>
          @article.applyChanges()
          this.renderArticle()
      when "destroyed"
        window.location.href = "/user/articles?message=deleted"

  _handlePublishing: ->
    document.getElementById('publish_article').addEventListener 'click', (e) =>
      e.preventDefault()
      e.target.textContent = 'Publishing...'
      @article.put("publish")
      .then (res) ->
        document.getElementById('publish_article').outerHTML = '<span>Published!</span>'
      .catch (err) ->
        e.target.textContent = 'Publish'
        flash = new FlashView alert: "Connection error!"
        flash.render()

  _updateEditLink: ->
    href = document.getElementById('edit_link').getAttribute('href')
    document.getElementById('edit_link').setAttribute('href', href.replace("/0/", "/#{@article.id}/"))

export default Show;
