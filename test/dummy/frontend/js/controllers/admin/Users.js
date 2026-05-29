import React from "react";
import { createRoot } from "react-dom/client";
import { helpers } from "simplicit";

import store from "store";

import { inlineList, inlineOne } from "utils/inline";
import User from "models/User";
import UserList from "containers/admin/UserList";
import renderUser from "views/admin/users/Show";
import renderForm from "views/admin/users/Form";

class Users {
  index() {
    const users = inlineList("users-data", User);
    store.dispatch({ type: "USERS.SET", users });
    createRoot(document.querySelector("table tbody")).render(
      <UserList users={users} />,
    );
  }

  show() {
    renderUser(inlineOne("user-data", User));
  }

  edit() {
    renderForm(new User({ id: helpers.params.id }));
  }
}

export default Users;
