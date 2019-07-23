export default (state = {}, action) => {
  switch (action.type) {
    case "SET_COMMENTS":
      return { [action.payload.articleId]: action.payload.comments };
    default:
      return state;
  }
};
