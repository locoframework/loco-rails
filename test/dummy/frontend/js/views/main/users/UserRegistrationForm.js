import { Views } from "loco-js";
import { UI } from "loco-js-ui";

import User from "models/User";
import Flash from "views/shared/Flash";

class UserRegistrationForm extends Views.Base {
  constructor(opts = {}) {
    super(opts);
  }

  render() {
    const form = new UI.Form({
      for: new User(),
      delegator: this,
      callbackSuccess: "_created"
    });
    form.render();
  }

  receivedSignal(signal) {
    switch (signal) {
      case "confirming":
        this._confirming();
        break;
      case "confirmed":
        this._confirmed();
    }
  }

  _created(data) {
    this.connectWith(new User({ id: data.id }));
    document.querySelector("form").style.display = "none";
    document.getElementById("sign_in_paragraph").classList.remove("none");
    document.getElementById("verification_info").classList.remove("none");
    const flash = new Flash({ notice: data.notice });
    flash.render();
  }

  _confirming() {
    document.getElementById(
      "verification_info"
    ).textContent = document.getElementById(
      "verification_progress"
    ).textContent;
  }

  _confirmed() {
    window.location.href = "/user/sessions/new?event=confirmed";
  }
}

export default UserRegistrationForm;
