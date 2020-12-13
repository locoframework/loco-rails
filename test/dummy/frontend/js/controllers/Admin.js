import App from "./App";
import Articles from "./admin/Articles";
import Comments from "./admin/Comments";
import Sessions from "./admin/Sessions";
import Users from "./admin/Users";

class Admin extends App {
  initialize() {
    this.setScope("admin");
  }
}

Admin.Articles = Articles;
Admin.Comments = Comments;
Admin.Sessions = Sessions;
Admin.Users = Users;

export default Admin;
