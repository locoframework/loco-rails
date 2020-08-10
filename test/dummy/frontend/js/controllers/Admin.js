import { Controllers } from "loco-js";

import Articles from "./admin/Articles";
import Comments from "./admin/Comments";
import Sessions from "./admin/Sessions";
import Users from "./admin/Users";

class Admin extends Controllers.Base {
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
