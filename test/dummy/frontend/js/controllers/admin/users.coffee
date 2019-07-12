import React from "react";
import { render as renderElement } from "react-dom";
import { Controllers } from "loco-js"

import store from "stores/admin";
import User from "models/user.coffee"
import UserListWrapper from "containers/admin/UserListWrapper"

class Users extends Controllers.Base
  index: ->
    User.get("all").then (resp) =>
      store.dispatch({ type: "SET", payload: { users: resp.resources } });
      renderElement(
        React.createElement(UserListWrapper, { users: resp.resources }),
        document.querySelector("table tbody")
      )

  show: ->
    view = new App.Views.Admin.Users.Show
    User.find(@params.id).then (user) => view.render user

  edit: ->
    view = new App.Views.Admin.Users.Form user: new User id: @params.id
    view.render()

export default Users
