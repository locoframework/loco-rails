import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "stores/main";
import { commentsForArticle } from "selectors/comments";
import Comment from "components/main/Comment";
import CommentModel from "models/article/Comment";

function StatefulCommentList(props) {
  const articleId = props.articleId;
  const [comments, setComments] = useState(props.comments);

  useEffect(() => {
    const unsubscribe = store.subscribe(() => {
      setComments(commentsForArticle(store.getState(), articleId));
    });

    return () => {
      unsubscribe();
    };
  });

  const list = comments.map(comment => (
    <Comment key={comment.id} comment={comment} />
  ));

  if (comments.length === 0) {
    return <p id="no_comments">No comments.</p>;
  }

  return <>{list}</>;
}

StatefulCommentList.propTypes = {
  articleId: PropTypes.number.isRequired,
  comments: PropTypes.arrayOf(PropTypes.instanceOf(CommentModel)).isRequired
};

export default StatefulCommentList;
