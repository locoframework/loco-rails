export default (state = {}, action) => {
  switch (action.type) {
    case "ADD_COMMENTS":
      return {
        ...state,
        [action.payload.articleId]: [
          ...state[action.payload.articleId],
          ...action.payload.comments
        ]
      };
    case "SET_COMMENTS":
      return { [action.payload.articleId]: action.payload.comments };
    default:
      return state;
  }
};
