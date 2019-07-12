import React from "react";
import { render as renderElement } from "react-dom";
import { Controllers } from "loco-js"

import User from "models/user.coffee"

import UserList from "components/admin/UserList"

class Users extends Controllers.Base
  index: ->
    this.connectWith [User]
    User.get("all").then (resp) =>
      renderElement(
        React.createElement(UserList, { users: resp.resources }),
        document.querySelector("table tbody")
      )

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
