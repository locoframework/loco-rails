import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "stores/user";
import { commentsForArticle } from "selectors/comments";
import Comment from "components/shared/Comment";
import CommentModel from "models/article/comment.coffee";

function CommentList(props) {
  const articleId = props.articleId;
  const [comments, setComments] = useState(props.comments);

  useEffect(() => {
    const unsubscribe = store.subscribe(() =>
      setComments(commentsForArticle(store.getState(), articleId))
    );

    return () => {
      unsubscribe();
    };
  });

  if (comments.length === 0) return <p>No comments.</p>;

  const list = comments.map(comment => (
    <Comment key={comment.id} comment={comment} />
  ));

  return <>{list}</>;
}

CommentList.propTypes = {
  articleId: PropTypes.number.isRequired,
  comments: PropTypes.arrayOf(PropTypes.instanceOf(CommentModel)).isRequired
};

export default CommentList;
