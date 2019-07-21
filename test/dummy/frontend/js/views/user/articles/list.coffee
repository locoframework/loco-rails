import { Views } from "loco-js"

class List extends Views.Base
  constructor: (opts = {}) ->
    super opts

  commentsQuantityChangedForArticle: (articleId, quantity) ->
    sel = document.querySelector("#article_#{articleId} td.comments_quantity")
    return unless sel
    match = /\d+/.exec(sel.textContent)
    quantity = parseInt(match[0]) + quantity
    sel.textContent = quantity

export default List;
