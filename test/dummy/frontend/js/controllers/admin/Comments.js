import { helpers } from "loco-js-core";

import renderForm from "views/admin/comments/Form";

class Comments {
  edit() {
    renderForm({ commentId: helpers.params.id });
  }
}

export default Comments;
