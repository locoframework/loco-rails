import Base from "./Base";
import Articles from "./user/Articles";
import Rooms from "./user/Rooms";

class User extends Base { }

User.Articles = Articles;
User.Rooms = Rooms;

export default User;
