import { Controllers, Mix } from "loco-js"

import Disconnection from "./concerns/disconnection.coffee"
import Users from "./admin/users.coffee"

class Admin extends Mix Controllers.Base, Disconnection
  initialize: -> this.setScope 'admin'

Object.assign(Admin, {
  Users
})

export default Admin
