import { Env, UI, Views } from "loco-js";

import CommentModel from "models/article/comment.coffee";

class Form extends Views.Base {
  constructor(opts = {}) {
    super(opts);
  }

  render(opts = {}) {
    const form = new UI.Form({
      for: new CommentModel({ id: opts.commentId, resource: "admin" }),
      id: `edit_comment_${opts.commentId}`,
      initObj: true
    });
    form.render();

    // only for testing purpose
    Env.test = { commentFormObj: form.getObj() };
  }
}

export default Form;
