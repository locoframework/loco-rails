export default (state = [], action) => {
  switch (action.type) {
    case "REMOVE_ARTICLE":
      return state.filter(article => article.id !== action.payload.id);
    case "SET_ARTICLES":
      return [...action.payload.articles];
    default:
      return state;
  }
};
