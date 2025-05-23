import { subscribe } from "loco-js";
import { UI } from "loco-js-ui";

import loco from "initializers/loco";

import User from "models/User";
import renderFlash from "views/shared/Flash";

const confirming = () => {
  document.getElementById("verification_info").textContent =
    document.getElementById("verification_progress").textContent;
};

const confirmed = () => {
  window.location.href = "/user/sessions/new?event=confirmed";
};

const receivedMessage = (type) => {
  switch (type) {
    case "confirming":
      confirming();
      break;
    case "confirmed":
      confirmed();
  }
};

const created = (data) => {
  loco.getWire().token = data.access_token;
  subscribe({ to: new User({ id: data.id }), with: receivedMessage });
  document.querySelector("form").style.display = "none";
  document.getElementById("sign_in_paragraph").classList.remove("none");
  document.getElementById("verification_info").classList.remove("none");
  renderFlash({ notice: data.notice });
};

export default () => {
  const form = new UI.Form({
    for: new User(),
    callbackSuccess: created,
  });
  form.render();
};
