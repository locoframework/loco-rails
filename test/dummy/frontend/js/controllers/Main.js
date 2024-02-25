import Base from "./Base";
import Articles from "./main/Articles";
import Pages from "./main/Pages";
import Users from "./main/Users";

class Main extends Base {
  initialize() {
    this.setScope("main");
  }
}

Main.Articles = Articles;
Main.Pages = Pages;
Main.Users = Users;

export default Main;
