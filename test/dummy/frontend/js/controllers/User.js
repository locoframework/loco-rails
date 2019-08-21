import { Controllers } from "loco-js";

import Disconnection from "./concerns/Disconnection";
import Articles from "./user/Articles";
import Rooms from "./user/Rooms";

Object.assign(Controllers.Base.prototype, Disconnection);

class User extends Controllers.Base {}

Object.assign(User, {
  Articles,
  Rooms
});

export default User;
