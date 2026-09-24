import { UI } from "loco-js-ui";

export default class Sessions {
  new() {
    new UI.Form({
      id: "sign_in_admin",
      callbackSuccess: () => (window.location.href = "/admin"),
    }).render();
  }
}
