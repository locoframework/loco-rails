import {
  ADD_COMMENTS,
  REMOVE_COMMENT,
  SET_COMMENTS,
  UPDATE_COMMENT
} from "actions";

export default (state = {}, action) => {
  switch (action.type) {
    case ADD_COMMENTS:
      return {
        ...state,
        [action.articleId]: [...state[action.articleId], ...action.comments]
      };
    case REMOVE_COMMENT:
      if (state[action.articleId] == null) return state;
      return {
        ...state,
        [action.articleId]: state[action.articleId].filter(
          comment => comment.id !== action.id
        )
      };
    case SET_COMMENTS:
      return { [action.articleId]: action.comments };
    case UPDATE_COMMENT: {
      const articleId = action.articleId;
      let index = action.index;
      if (!index) {
        const comment = state[articleId].find(c => c.id === action.comment.id);
        index = state[articleId].indexOf(comment);
      }
      return {
        ...state,
        [articleId]: [
          ...state[articleId].slice(0, index),
          action.comment,
          ...state[articleId].slice(index + 1)
        ]
      };
    }
    default:
      return state;
  }
};
