import React from "react";
import { render as renderElement } from "react-dom";
import { helpers, Controllers } from "loco-js";

import { setUsers } from "actions";
import store from "store";

import User from "models/User";
import UserList from "containers/admin/UserList";
import Show from "views/admin/users/Show";
import Form from "views/admin/users/Form";

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
    new Show({ user: user }).render();
  }

  edit() {
    const view = new Form({ user: new User({ id: helpers.params.id }) });
    view.render();
  }
}

export default Users;
