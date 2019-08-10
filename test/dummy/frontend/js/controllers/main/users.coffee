import { Controllers } from "loco-js"

import UserRegistrationForm from "views/main/users/user_registration_form.coffee"

class Users extends Controllers.Base
  new: ->
    view = new UserRegistrationForm
    view.render()

export default Users
