import { Controllers, Mix } from "loco-js";

import Disconnection from "./concerns/disconnection.coffee";
import Articles from "./admin/Articles";
import Comments from "./admin/Comments";
import Users from "./admin/Users";

class Admin extends Mix(Controllers.Base, Disconnection) {
  initialize() {
    this.setScope("admin");
  }
}

Object.assign(Admin, {
  Articles,
  Comments,
  Users
});

export default Admin;