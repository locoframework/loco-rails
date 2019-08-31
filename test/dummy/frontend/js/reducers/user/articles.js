import { ADD_ARTICLES, SET_ARTICLES } from "actions/shared";
import { REMOVE_ARTICLE } from "actions/user";

export default (state = [], action) => {
  switch (action.type) {
    case ADD_ARTICLES:
      return [...state, ...action.payload.articles];
    case REMOVE_ARTICLE:
      return state.filter(article => article.id !== action.payload.id);
    case SET_ARTICLES:
      return [...action.payload.articles];
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
