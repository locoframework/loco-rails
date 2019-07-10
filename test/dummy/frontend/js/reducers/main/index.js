const reducer = (state, action) => {
  switch (action.type) {
    case "ADD":
      return { articles: [...state.articles, ...action.payload.articles] };
    default:
      return state;
  }
};

export default reducer;
