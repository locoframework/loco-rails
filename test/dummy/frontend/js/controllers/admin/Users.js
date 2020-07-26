import React from "react";
import { render as renderElement } from "react-dom";
import { helpers, Controllers } from "loco-js";

import { setUsers } from "actions";
import store from "store";

import User from "models/User";
import UserList from "containers/admin/UserList";
import renderUser from "views/admin/users/Show";
import renderForm from "views/admin/users/Form";

class Users extends Controllers.Base {
  async index() {
    const resp = await User.get("all");
    store.dispatch(setUsers(resp.resources));
    renderElement(
      <UserList users={resp.resources} />,
      document.querySelector("table tbody")
    );
  }

  async show() {
    const user = await User.find(helpers.params.id);
    renderUser(user);
  }

  edit() {
    renderForm(new User({ id: helpers.params.id }));
  }
}

export default Users;
