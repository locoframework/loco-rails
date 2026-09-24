import Base from "controllers/Base";
import renderUserRegistrationForm from "views/main/users/UserRegistrationForm";

export default class Users extends Base {
  new() {
    this.unsubscribe = renderUserRegistrationForm();
  }
}
