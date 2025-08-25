import { produce } from "immer";

import { PREPEND_USERS, SET_USERS } from "actions";

export default produce((draft = [], action) => {
  switch (action.type) {
    case SET_USERS:
      return action.users;
    case PREPEND_USERS:
      return action.users.concat(draft);
    default:
      return draft;
  }
});
