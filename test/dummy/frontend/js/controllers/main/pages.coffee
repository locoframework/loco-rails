import { Controllers } from "loco-js"
import ArticleList from "views/main/pages/article_list.coffee"

class Pages extends Controllers.Base
  index: ->
    (new ArticleList).render()

export default Pages