import { UI, Views } from "loco-js";

class Form extends Views.Base {
  constructor(opts = {}) {
    super(opts);
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
