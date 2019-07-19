import { Controllers } from "loco-js";

import Admin from "controllers/Admin";
import Main from "controllers/Main";
import User from "controllers/User";

Object.assign(Controllers, {
  Admin,
  Main,
  User
});
