import { Controllers, Mix } from "loco-js"

import Disconnection from "./concerns/disconnection.coffee"
import Articles from "./admin/articles.coffee";
import Users from "./admin/Users";

class Admin extends Mix Controllers.Base, Disconnection
  initialize: -> this.setScope 'admin'

Object.assign(Admin, {
  Articles,
  Users
})

export default Admin
