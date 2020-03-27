import { subscribe } from "loco-js";
import { UI } from "loco-js-ui";

import User from "models/User";
import renderFlash from "views/shared/Flash";

const confirming = () => {
  document.getElementById(
    "verification_info"
  ).textContent = document.getElementById("verification_progress").textContent;
};

const confirmed = () => {
  window.location.href = "/user/sessions/new?event=confirmed";
};

const receivedSignal = signal => {
  switch (signal) {
    case "confirming":
      confirming();
      break;
    case "confirmed":
      confirmed();
  }
};

class UserRegistrationForm {
  render() {
    const form = new UI.Form({
      for: new User(),
      delegator: this,
      callbackSuccess: "_created"
    });
    form.render();
  }

  _created(data) {
    subscribe({ to: new User({ id: data.id }), with: receivedSignal });
    document.querySelector("form").style.display = "none";
    document.getElementById("sign_in_paragraph").classList.remove("none");
    document.getElementById("verification_info").classList.remove("none");
    renderFlash({ notice: data.notice });
  }
}

export default UserRegistrationForm;
