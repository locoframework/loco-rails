import Article from "./article.coffee";
import Comment from "./article/comment.coffee";

Object.assign(Article, { Comment });

const Models = {
  Article
};

export default Models;
