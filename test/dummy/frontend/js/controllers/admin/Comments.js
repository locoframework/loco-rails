import { helpers, Controllers } from "loco-js";

import renderForm from "views/admin/comments/Form";

class Comments extends Controllers.Base {
  edit() {
    renderForm({ commentId: helpers.params.id });
  }
}

export default Comments;
