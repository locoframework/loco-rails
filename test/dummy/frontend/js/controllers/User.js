import App from "./App";
import Articles from "./user/Articles";
import Rooms from "./user/Rooms";

class User extends App {}

User.Articles = Articles;
User.Rooms = Rooms;

export default User;
