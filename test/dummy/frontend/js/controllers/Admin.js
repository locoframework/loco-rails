import { Controllers, Mix } from "loco-js";

import Disconnection from "./concerns/Disconnection";
import Articles from "./admin/Articles";
import Comments from "./admin/Comments";
import Sessions from "./admin/Sessions";
import Users from "./admin/Users";

class Admin extends Mix(Controllers.Base, Disconnection) {
  initialize() {
    this.setScope("admin");
  }
}

Object.assign(Admin, {
  Articles,
  Comments,
  Sessions,
  Users
});

export default Admin;
