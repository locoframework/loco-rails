import store from "store";
import User from "models/User";
import { adminNamespace } from "services/namespace";

export const created = async ({ id }) => {
  const user = await User.find(id);
  User.add(user);
  store.dispatch({ type: "USERS.ADD", users: [user] });
};

export const confirmed = ({ id }) => {
  if (adminNamespace()) {
    User.byId(id)?.update({ confirmed: true });
    store.dispatch({ type: "USERS.UPDATE", user: { id, confirmed: true } });
  } else {
    window.location.href = "/user/sessions/new?event=confirmed";
  }
};
