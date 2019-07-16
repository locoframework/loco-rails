export default (state = [], action) => {
  switch (action.type) {
    case "SET_COMMENTS":
      return [...action.payload.comments];
    default:
      return state;
  }
};
