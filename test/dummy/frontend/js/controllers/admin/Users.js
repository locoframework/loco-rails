import { helpers } from "simplicit";

import User from "models/User";
import renderForm from "views/admin/users/Form";

class Users {
  edit() {
    renderForm(new User({ id: helpers.params.id }));
  }
}

export default Users;
