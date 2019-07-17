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
    case "REMOVE_COMMENT":
      return {
        ...state,
        [action.payload.articleId]: state[action.payload.articleId].filter(
          comment => comment.id !== action.payload.id
        )
      };
    case "SET_COMMENTS":
      return { [action.payload.articleId]: action.payload.comments };
    default:
      return state;
  }
};
