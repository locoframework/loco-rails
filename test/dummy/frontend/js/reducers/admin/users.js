const users = (state = [], action) => {
  switch (action.type) {
    case "APPEND_USER":
      return [...state, ...action.payload.users];
    case "SET_USERS":
      return [...action.payload.users];
    case "PREPEND_USER":
      return [...action.payload.users, ...state];
    default:
      return state;
  }
};

export default users;
