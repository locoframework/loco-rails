import { UI } from "loco-js-ui";
import { helpers } from "simplicit";

import User from "models/User";

export default class Users {
  edit() {
    const form = new UI.Form({
      for: new User({ id: helpers.params.id }),
      initObj: true,
      id: "admin_user_form",
    });
    form.render();
  }
}
