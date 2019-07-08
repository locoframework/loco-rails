import { Controllers } from "loco-js"

import User from "models/user.coffee"
import List from "views/admin/users/list.coffee"

class Users extends Controllers.Base
  index: ->
    @view = new List users: []
    @view.render()
    this.connectWith [User]
    User.get("all").then (resp) => @view.renderUsers resp.resources

  show: ->
    view = new App.Views.Admin.Users.Show
    User.find(@params.id).then (user) => view.render user

  edit: ->
    view = new App.Views.Admin.Users.Form user: new User id: @params.id
    view.render()

  receivedSignal: (signal, data) ->
    switch signal
      when "User created"
        User.find(data.id).then (user) => @view.renderUsers [user], 'prepend'

export default Users
