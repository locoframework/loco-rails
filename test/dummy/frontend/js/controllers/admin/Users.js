import React from "react";
import { render as renderElement } from "react-dom";
import { Controllers } from "loco-js";

import store from "stores/admin";
import User from "models/user.coffee";
import UserList from "containers/admin/StatefulUserList";
import Show from "views/admin/users/Show";
import Form from "views/admin/users/Form";

class Users extends Controllers.Base {
  index() {
    User.get("all").then(resp => {
      store.dispatch({ type: "SET_USERS", payload: { users: resp.resources } });
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
