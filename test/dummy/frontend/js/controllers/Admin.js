import Base from "./Base";
import Articles from "./admin/Articles";
import Comments from "./admin/Comments";
import Sessions from "./admin/Sessions";
import Users from "./admin/Users";

class Admin extends Base {
  initialize() {
    this.setScope("admin");
  }
}

Admin.Articles = Articles;
Admin.Comments = Comments;
Admin.Sessions = Sessions;
Admin.Users = Users;

export default Admin;
