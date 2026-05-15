import { produce } from "immer";

import { PREPEND_USERS, SET_USERS, UPDATE_USER } from "actions";

export default produce((draft = [], action) => {
  switch (action.type) {
    case SET_USERS:
      return action.users;
    case PREPEND_USERS:
      return action.users.concat(draft);
    case UPDATE_USER: {
      const idx = draft.findIndex((u) => u.id === action.user.id);
      if (idx !== -1) draft[idx] = { ...draft[idx], ...action.user };
      return draft;
    }
    default:
      return draft;
  }
});
