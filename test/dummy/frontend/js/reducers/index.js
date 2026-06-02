import { combineReducers } from "redux";

import resourceReducer from "./resourceReducer";

export default combineReducers({
  articles: resourceReducer("article"),
  comments: resourceReducer("comment", { nestedBy: "articleId" }),
  users: resourceReducer("user"),
});
