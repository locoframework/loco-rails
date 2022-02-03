import { combineReducers } from "redux";

import articles from "./articles";
import comments from "./comments";
import users from "./users";

export default combineReducers({
  articles,
  comments,
  users,
});
