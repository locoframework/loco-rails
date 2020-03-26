import { UI } from "loco-js-ui";

class Form {
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
