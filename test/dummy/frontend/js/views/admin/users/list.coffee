import React from "react";
import { render as renderElement } from "react-dom";
import { Views } from "loco-js"

import UserList from "components/admin/UserList"

class List extends Views.Base
  constructor: (opts = {}) ->
    super opts
    @users = opts.users

  render: ->
    document.querySelector("table tbody").innerHTML = ''

  renderUsers: (users, order = 'append') ->
    renderElement(
      React.createElement(UserList, {users: users, order: order}),
      document.querySelector("table tbody")
    )
    #for user in users
    #  renderedUser = JST["templates/admin/users/user"] {user: user}
    #  if order is 'append'
    #    document.querySelector("table").insertAdjacentHTML('beforeend', renderedUser)
    #  else
    #    document.querySelector("table").insertAdjacentHTML('afterbegin', renderedUser)
    #for el in document.querySelectorAll('table a.ping')
    #  el.addEventListener 'click', (e) ->
    #    e.preventDefault()
    #    userId = e.target.parentNode.parentNode.getAttribute('data-id')
    #    App.Env.loco.emit(signal: 'ping', user_id: userId)

export default List
