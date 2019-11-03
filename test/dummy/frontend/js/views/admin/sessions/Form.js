import { Views } from "loco-js";
import { UI } from "loco-js-ui";

class Form extends Views.Base {
  constructor(opts = {}) {
    super(opts);
  }

  render() {
    const form = new UI.Form({
      id: "sign_in_admin",
      delegator: this,
      callbackSuccess: "_signedIn"
    });
    form.render();
  }

  _signedIn() {
    window.location.href = "/admin";
  }
}

export default Form;
