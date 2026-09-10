import User from "models/User";
import { adminNamespace } from "services/namespace";

export const created = async ({ id }) => {
  User.add(await User.find(id));
};

export const confirmed = ({ id }) => {
  if (adminNamespace()) {
    User.byId(id)?.update({ confirmed: true });
  } else {
    window.location.href = "/user/sessions/new?event=confirmed";
  }
};
