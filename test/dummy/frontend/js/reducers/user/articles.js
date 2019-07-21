export default (state = [], action) => {
  switch (action.type) {
    case "SET_ARTICLES":
      return [...action.payload.articles];
    default:
      return state;
  }
};
