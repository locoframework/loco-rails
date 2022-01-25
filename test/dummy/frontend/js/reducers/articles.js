import produce from "immer";

import {
  ADD_ARTICLES,
  PREPEND_ARTICLES,
  REMOVE_ARTICLE,
  SET_ARTICLES,
  UPDATE_ARTICLE,
} from "actions";

export default produce((draft = [], action) => {
  switch (action.type) {
    case ADD_ARTICLES:
      return draft.concat(action.articles);
    case PREPEND_ARTICLES:
      return action.articles.concat(draft);
    case REMOVE_ARTICLE:
      return draft.filter((article) => article.id !== action.id);
    case SET_ARTICLES:
      return action.articles;
    case UPDATE_ARTICLE:
      draft[action.index] = action.article;
      break;
    default:
      return draft;
  }
});
