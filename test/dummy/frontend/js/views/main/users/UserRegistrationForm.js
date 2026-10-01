import { subscribe } from "loco-js";
import { UI } from "loco-js-ui";

import { renderFlash } from "services/app";
import User from "models/User";

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
  const unsubscribe = subscribe({
    to: new User({ id: data.id }),
    with: receivedMessage,
  });
  document.querySelector("form").style.display = "none";
  document.getElementById("sign_in_paragraph").classList.remove("none");
  document.getElementById("verification_info").classList.remove("none");
  renderFlash({ notice: data.notice });
  return unsubscribe;
};

export default () => {
  let unsubscribe = null;
  const form = new UI.Form({
    for: new User(),
    callbackSuccess: (data) => (unsubscribe = created(data)),
  });
  form.render();
  return () => unsubscribe?.();
};
