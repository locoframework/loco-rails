import React from "react";
import { render as renderElement } from "react-dom";
import { Controllers } from "loco-js";

import { setUsers } from "actions/admin";
import store from "stores/admin";

import User from "models/User";
import UserList from "containers/admin/UserList";
import Show from "views/admin/users/Show";
import Form from "views/admin/users/Form";

class Users extends Controllers.Base {
  index() {
    User.get("all").then(resp => {
      store.dispatch(setUsers(resp.resources));
      renderElement(
        <UserList users={resp.resources} />,
        document.querySelector("table tbody")
      );
    });
  }

  show() {
    User.find(this.params.id).then(user => new Show({ user: user }).render());
  }

  edit() {
    const view = new Form({ user: new User({ id: this.params.id }) });
    view.render();
  }
}

export default Users;
