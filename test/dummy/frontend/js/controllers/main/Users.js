import { Controllers } from "loco-js";

import renderUserRegistrationForm from "views/main/users/UserRegistrationForm";

class Users extends Controllers.Base {
  new() {
    renderUserRegistrationForm();
  }
}

export default Users;
