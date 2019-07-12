import Article from "./article.coffee";
import Comment from "./article/comment.coffee";
import User from "./user.coffee";

Object.assign(Article, { Comment });

const Models = {
  Article,
  User
};

export default Models;
