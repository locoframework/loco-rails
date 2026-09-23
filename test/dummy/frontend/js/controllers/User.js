import Base from "./Base";
import Articles from "./user/Articles";

export default class User extends Base {
  initialize() {
    this.setScope(null);
  }
}

User.Articles = Articles;
