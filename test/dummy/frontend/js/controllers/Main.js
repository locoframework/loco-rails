import Base from "./Base";
import Articles from "./main/Articles";
import Users from "./main/Users";

export default class Main extends Base {
  initialize() {
    this.setScope("main");
  }
}

Main.Articles = Articles;
Main.Users = Users;
