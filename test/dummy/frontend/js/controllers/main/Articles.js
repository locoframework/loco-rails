import { UI } from "loco-js-ui";
import { helpers } from "simplicit";

import Comment from "models/article/Comment";

export default class Articles {
  show() {
    const form = new UI.Form({
      for: new Comment({ articleId: helpers.params.id }),
      initObj: true,
      id: "new_comment",
    });
    form.render();
  }
}
