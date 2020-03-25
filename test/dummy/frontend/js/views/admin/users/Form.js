import { Views } from "loco-js";
import { UI } from "loco-js-ui";

class Form extends Views.Base {
  constructor(opts = {}) {
    super();
    this.user = opts.user;
  }

  render() {
    const form = new UI.Form({
      for: this.user,
      initObj: true,
      id: "admin_user_form"
    });
    form.render();
  }
}

export default Form;
