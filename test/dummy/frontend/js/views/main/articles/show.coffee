import { Helpers, Services, UI, Views } from "loco-js";

import Flash from "views/shared/flash.coffee";

class Show extends Views.Base
  constructor: (opts = {}) ->
    super opts
    @article = null
    @newComment = opts.comment

  render: ->
    form = new UI.Form for: @newComment, initObj: true, id: "new_comment"
    form.render()

  renderArticle: (article = null) ->
    if not @article?
      @article = article
      this.connectWith @article, receiver: "_articleReceivedSignal"
    document.getElementById("title").textContent = @article.title
    document.getElementById("author").textContent = @article.author
    dateService = new Services.Date @article.publishedAt
    document.getElementById("pub_date").textContent = dateService.toString('short')
    textEl = document.getElementById "text"
    textEl.innerHTML = ""
    text = (new Helpers.Text).simpleFormat @article.content
    textEl.insertAdjacentHTML "beforeend", text

  _articleReceivedSignal: (signal, data) ->
    switch signal
      when 'updating'
        txt = 'Author is currently editing article. Be aware of possible changes.'
        flash = new Flash warning: txt
        flash.render()
      when 'updated'
        @article.reload().then =>
          @article.applyChanges()
          this.renderArticle()

export default Show