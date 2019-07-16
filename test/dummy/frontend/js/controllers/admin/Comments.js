import { Controllers } from "loco-js";

import Form from "views/admin/comments/Form";

class Comments extends Controllers.Base {
  edit() {
    new Form().render({ commentId: this.params.id });
  }
}

export default Comments;
