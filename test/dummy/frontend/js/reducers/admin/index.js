const reducer = (state, action) => {
  switch (action.type) {
    case "APPEND":
      return { users: [...state.users, ...action.payload.users] };
    case "SET":
      return { users: [...action.payload.users] };
    case "PREPEND":
      return { users: [...action.payload.users, ...state.users] };
    default:
      return state;
  }
};

export default reducer;
