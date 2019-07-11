const reducer = (state, action) => {
  switch (action.type) {
    case "SET":
      return { articles: [...action.payload.articles] };
    case "ADD":
      return { articles: [...state.articles, ...action.payload.articles] };
    default:
      return state;
  }
};

export default reducer;
