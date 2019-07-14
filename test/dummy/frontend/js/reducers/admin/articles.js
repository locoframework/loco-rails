const articles = (state = [], action) => {
  switch (action.type) {
    case "PREPEND_ARTICLE":
      return [...action.payload.articles, ...state];
    case "SET_ARTICLES":
      return [...action.payload.articles];
    default:
      return state;
  }
};

export default articles;
