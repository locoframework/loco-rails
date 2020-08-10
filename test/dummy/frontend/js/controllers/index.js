import { Controllers } from "loco-js";

import Disconnection from "./concerns/Disconnection";

import Admin from "controllers/Admin";
import Main from "controllers/Main";
import User from "controllers/User";

Object.assign(Controllers.Base.prototype, Disconnection);

Object.assign(Controllers, {
  Admin,
  Main,
  User
});
