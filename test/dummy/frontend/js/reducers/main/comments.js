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
        [action.payload.articleId]: [
          ...state[action.payload.articleId],
          ...action.payload.comments
        ]
      };
    case REMOVE_COMMENT:
      if (state[action.payload.articleId] == null) return state;
      return {
        ...state,
        [action.payload.articleId]: state[action.payload.articleId].filter(
          comment => comment.id !== action.payload.id
        )
      };
    case SET_COMMENTS:
      return { [action.payload.articleId]: action.payload.comments };
    case UPDATE_COMMENT: {
      const articleId = action.payload.articleId;
      const index = action.payload.index;
      return {
        ...state,
        [articleId]: [
          ...state[articleId].slice(0, index),
          action.payload.comment,
          ...state[articleId].slice(index + 1)
        ]
      };
    }
    default:
      return state;
  }
};
