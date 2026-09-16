import Base from "./Base";
import Articles from "./user/Articles";

class User extends Base {
  initialize() {
    this.setScope(null);
  }
}

User.Articles = Articles;

export default User;
