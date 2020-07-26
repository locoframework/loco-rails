import { UI } from "loco-js-ui";

export default user => {
  const form = new UI.Form({
    for: user,
    initObj: true,
    id: "admin_user_form"
  });
  form.render();
};
