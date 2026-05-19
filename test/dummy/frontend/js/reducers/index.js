import { combineReducers } from "redux";

import common from "./common";
import comments from "./comments";

export default combineReducers({
  articles: common("article"),
  comments,
  users: common("user"),
});
