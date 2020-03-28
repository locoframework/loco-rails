import { Env } from "loco-js";
import { UI } from "loco-js-ui";

import CommentModel from "models/article/Comment";

export default (opts = {}) => {
  const form = new UI.Form({
    for: new CommentModel({ id: opts.commentId, resource: "admin" }),
    id: `edit_comment_${opts.commentId}`,
    initObj: true
  });
  form.render();

  // only for testing purpose
  Env.test = { commentFormObj: form.getObj() };
};
