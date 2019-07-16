export default (state = [], action) => {
  switch (action.type) {
    case "SET_ARTICLES":
      return [...action.payload.articles];
    case "ADD_ARTICLES":
      return [...state, ...action.payload.articles];
    case "UPDATE_ARTICLE":
      return [
        ...state.slice(0, action.payload.index),
        action.payload.article,
        ...state.slice(action.payload.index + 1)
      ];
    default:
      return state;
  }
};
