import React from "react";
import { createRoot } from "react-dom/client";
import { helpers } from "simplicit";

import store from "store";

import User from "models/User";
import UserList from "containers/admin/UserList";
import renderUser from "views/admin/users/Show";
import renderForm from "views/admin/users/Form";

class Users {
  index() {
    const users = JSON.parse(
      document.getElementById("users-data").textContent,
    ).map((u) => new User(u));
    store.dispatch({ type: "USERS.SET", users });
    createRoot(document.querySelector("table tbody")).render(
      <UserList users={users} />,
    );
  }

  show() {
    const user = new User(
      JSON.parse(document.getElementById("user-data").textContent),
    );
    renderUser(user);
  }

  edit() {
    renderForm(new User({ id: helpers.params.id }));
  }
}

export default Users;
