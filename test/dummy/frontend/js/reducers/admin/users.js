import { PREPEND_USERS, SET_USERS } from "actions/admin";

export default (state = [], action) => {
  switch (action.type) {
    case SET_USERS:
      return [...action.payload.users];
    case PREPEND_USERS:
      return [...action.payload.users, ...state];
    default:
      return state;
  }
};
