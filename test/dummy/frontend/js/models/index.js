import { Models } from "loco-js";

import Article from "./article.coffee";
import Comment from "./article/comment.coffee";
import User from "./user.coffee";

Object.assign(Article, { Comment });

Object.assign(Models, {
  Article,
  User
});
