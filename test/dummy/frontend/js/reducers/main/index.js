import { combineReducers } from "redux";

import articles from "../articles";
import comments from "./comments";

export default combineReducers({
  articles,
  comments
});
