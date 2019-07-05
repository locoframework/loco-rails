import { Controllers, Mix, Mixins } from "loco-js"
import Disconnection from "controllers/concerns/disconnection.coffee"
import Pages from "./main/pages.coffee"

class Main extends Mix Controllers.Base, Disconnection
  initialize: -> this.setScope 'main'

Object.assign(Main, {
  Pages
})

export default Main