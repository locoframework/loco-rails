export const findArticle = (state, id) => {
  const article = state.articles.find(a => a.id === id);
  if (!article) return [null, null];
  const index = state.articles.indexOf(article);
  return [article, index];
};
