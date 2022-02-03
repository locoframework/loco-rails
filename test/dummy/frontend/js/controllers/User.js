import { Controllers } from "loco-js";

import Articles from "./user/Articles";
import Rooms from "./user/Rooms";

class User extends Controllers.Base {}

User.Articles = Articles;
User.Rooms = Rooms;

export default User;
