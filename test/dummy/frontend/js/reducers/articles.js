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
      return [...state, ...action.payload.articles];
    case PREPEND_ARTICLES:
      return [...action.payload.articles, ...state];
    case REMOVE_ARTICLE:
      return state.filter(article => article.id !== action.payload.id);
    case SET_ARTICLES:
      return [...action.payload.articles];
    case UPDATE_ARTICLE:
      return [
        ...state.slice(0, action.payload.index),
        action.payload.article,
        ...state.slice(action.payload.index + 1)
      ];
    default:
      return state;
  }
};
