import { combineReducers } from "redux";

import common from "./common";

export default combineReducers({
  articles: common("article"),
  comments: common("comment", { nestedBy: "articleId" }),
  users: common("user"),
});
