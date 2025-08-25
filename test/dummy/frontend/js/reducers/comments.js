import { produce } from "immer";

import {
  ADD_COMMENTS,
  REMOVE_COMMENT,
  SET_COMMENTS,
  UPDATE_COMMENT,
} from "actions";

export default produce((draft = {}, action) => {
  switch (action.type) {
    case ADD_COMMENTS:
      if (draft[action.articleId] === undefined) {
        draft[action.articleId] = [];
      }
      draft[action.articleId] = draft[action.articleId].concat(action.comments);
      break;
    case REMOVE_COMMENT:
      if (draft[action.articleId] == null) return draft;
      draft[action.articleId] = draft[action.articleId].filter(
        (comment) => comment.id !== action.id,
      );
      break;
    case SET_COMMENTS:
      draft[action.articleId] = action.comments;
      break;
    case UPDATE_COMMENT: {
      const articleId = action.articleId;
      let index = action.index;
      if (!index) {
        const comment = draft[articleId].find(
          (c) => c.id === action.comment.id,
        );
        index = draft[articleId].indexOf(comment);
      }
      draft[articleId][index] = action.comment;
      break;
    }
    default:
      return draft;
  }
});
