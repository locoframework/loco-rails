import {
  ADD_ARTICLES,
  PREPEND_ARTICLES,
  REMOVE_ARTICLE,
  SET_ARTICLES,
  UPDATE_ARTICLE
} from "actions";

export default (state = [], action) => {
  switch (action.type) {
    case ADD_ARTICLES:
      return [...state, ...action.articles];
    case PREPEND_ARTICLES:
      return [...action.articles, ...state];
    case REMOVE_ARTICLE:
      return state.filter(article => article.id !== action.id);
    case SET_ARTICLES:
      return [...action.articles];
    case UPDATE_ARTICLE:
      return [
        ...state.slice(0, action.index),
        action.article,
        ...state.slice(action.index + 1)
      ];
    default:
      return state;
  }
};
