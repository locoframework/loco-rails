import { Controllers, Mix, Mixins } from "loco-js"
import Disconnection from "controllers/concerns/disconnection.coffee"

class Main extends Mix Controllers.Base, Disconnection
  initialize: -> this.setScope 'main'

export default Main