import { Controllers, Mix } from "loco-js"

import Disconnection from "./concerns/disconnection.coffee"
import Pages from "./main/Pages"
import Users from "./main/users.coffee"

class Main extends Mix Controllers.Base, Disconnection
  initialize: -> this.setScope 'main'

Object.assign(Main, {
  Pages,
  Users
})

export default Main