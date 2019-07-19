import { Controllers, Mix } from "loco-js";

import Disconnection from "./concerns/disconnection.coffee";
import Articles from "./user/articles.coffee";

class User extends Mix(Controllers.Base, Disconnection) {}

Object.assign(User, {
  Articles
});

export default User;
