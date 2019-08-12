import { Controllers, Mix } from "loco-js";

import Disconnection from "./concerns/disconnection.coffee";
import Articles from "./user/articles.coffee";
import Rooms from "./user/Rooms";

class User extends Mix(Controllers.Base, Disconnection) {}

Object.assign(User, {
  Articles,
  Rooms
});

export default User;
