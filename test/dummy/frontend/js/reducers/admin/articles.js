import { PREPEND_ARTICLES } from "actions";
import { SET_ARTICLES, UPDATE_ARTICLE } from "actions";

export default (state = [], action) => {
  switch (action.type) {
    case PREPEND_ARTICLES:
      return [...action.payload.articles, ...state];
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
