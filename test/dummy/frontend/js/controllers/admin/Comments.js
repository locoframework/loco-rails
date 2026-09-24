import { UI } from "loco-js-ui";
import { helpers } from "simplicit";

import CommentModel from "models/article/Comment";

export default class Comments {
  edit() {
    const commentId = helpers.params.id;
    const form = new UI.Form({
      for: new CommentModel({ id: commentId, resource: "admin" }),
      id: `edit_comment_${commentId}`,
      initObj: true,
    });
    form.render();

    // only for testing purpose
    window.test = { commentFormObj: form.getObj() };
  }
}
