const reducer = (state, action) => {
  switch (action.type) {
    case "SET":
      return { articles: [...action.payload.articles] };
    case "ADD":
      return { articles: [...state.articles, ...action.payload.articles] };
    case "UPDATE":
      return {
        articles: [
          ...state.articles.slice(0, action.payload.index),
          action.payload.article,
          ...state.articles.slice(action.payload.index + 1)
        ]
      };
    default:
      return state;
  }
};

export default reducer;

export const findArticle = (state, id) => {
  const article = state.articles.find(a => a.id === id);
  if (!article) return [null, null];
  const index = state.articles.indexOf(article);
  return [article, index];
};
