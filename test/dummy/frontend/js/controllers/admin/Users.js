import { helpers } from "simplicit";

import { inlineOne } from "utils/inline";
import User from "models/User";
import renderUser from "views/admin/users/Show";
import renderForm from "views/admin/users/Form";

class Users {
  show() {
    renderUser(inlineOne("user-data", User));
  }

  edit() {
    renderForm(new User({ id: helpers.params.id }));
  }
}

export default Users;
