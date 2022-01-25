import { UI } from "loco-js-ui";

const signedIn = () => (window.location.href = "/admin");

export default () => {
  const form = new UI.Form({
    id: "sign_in_admin",
    callbackSuccess: signedIn,
  });
  form.render();
};
