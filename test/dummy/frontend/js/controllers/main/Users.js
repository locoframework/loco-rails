import { Controllers } from "loco-js";

import UserRegistrationForm from "views/main/users/UserRegistrationForm";

class Users extends Controllers.Base {
  new() {
    new UserRegistrationForm().render();
  }
}

export default Users;
