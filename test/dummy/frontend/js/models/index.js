import { Models } from "loco-js";

import Article from "./article.coffee";
import Comment from "./article/comment.coffee";
import Member from "./room/member.coffee";
import Room from "./room.coffee";
import User from "./user.coffee";

Object.assign(Article, { Comment });
Object.assign(Room, { Member });

Object.assign(Models, {
  Article,
  Room,
  User
});
