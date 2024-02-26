import Base from "./Base";
import Articles from "./user/Articles";
import Rooms from "./user/Rooms";

class User extends Base {
  initialize() {
    this.setScope(null);
  }
}

User.Articles = Articles;
User.Rooms = Rooms;

export default User;
