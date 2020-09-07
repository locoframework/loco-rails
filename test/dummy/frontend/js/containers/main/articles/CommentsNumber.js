import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "store";
import { commentsForArticle } from "selectors/comments";
import CommentModel from "models/article/Comment";

function CommentsNumber(props) {
  const [comments, setComments] = useState(props.comments);

  useEffect(() => {
    const unsubscribe = store.subscribe(() => {
      setComments(commentsForArticle(store.getState(), props.articleId));
    });

    return () => {
      unsubscribe();
    };
  }, []);

  return <>{`${comments.length} comment${comments.length === 1 ? "" : "s"}`}</>;
}

CommentsNumber.propTypes = {
  articleId: PropTypes.number.isRequired,
  comments: PropTypes.arrayOf(PropTypes.instanceOf(CommentModel)).isRequired
};

export default CommentsNumber;
