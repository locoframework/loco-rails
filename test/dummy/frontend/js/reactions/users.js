import store from "store";
import User from "models/User";
import { adminNamespace } from "services/namespace";

export const created = async ({ id }) => {
  const user = await User.find(id);
  store.dispatch({ type: "USERS.ADD", users: [user] });
};

export const confirmed = ({ id }) => {
  if (adminNamespace()) {
    store.dispatch({ type: "USERS.UPDATE", user: { id, confirmed: true } });
  } else {
    window.location.href = "/user/sessions/new?event=confirmed";
  }
};
