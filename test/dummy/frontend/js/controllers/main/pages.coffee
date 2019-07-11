import { Controllers } from "loco-js"
import ArticleList from "views/main/pages/ArticleList"

class Pages extends Controllers.Base
  index: ->
    (new ArticleList).render()

export default Pages