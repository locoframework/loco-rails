import { Controllers } from "loco-js";

import Articles from "./user/Articles";
import Rooms from "./user/Rooms";

class User extends Controllers.Base {}

Object.assign(User, {
  Articles,
  Rooms
});

export default User;
