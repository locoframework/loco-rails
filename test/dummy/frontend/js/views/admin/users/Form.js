import { UI } from "loco-js-ui";

class Form {
  constructor(opts = {}) {
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
