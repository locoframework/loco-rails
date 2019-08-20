import { Controllers, Mix } from "loco-js";

import Disconnection from "./concerns/Disconnection";
import Articles from "./user/Articles";
import Rooms from "./user/Rooms";

class User extends Mix(Controllers.Base, Disconnection) {}

Object.assign(User, {
  Articles,
  Rooms
});

export default User;
