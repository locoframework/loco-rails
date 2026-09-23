import { helpers } from "simplicit";

import renderForm from "views/admin/comments/Form";

export default class Comments {
  edit() {
    renderForm({ commentId: helpers.params.id });
  }
}
