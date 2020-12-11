import { Models } from "loco-js";

import Article from "./Article";
import Comment from "./article/Comment";
import Member from "./room/Member";
import Room from "./Room";
import User from "./User";

Object.assign(Models, {
  Article: Object.assign(Article, { Comment }),
  Room: Object.assign(Room, { Member }),
  User
});
