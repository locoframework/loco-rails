import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "store";
import { commentsForArticle } from "selectors";
import CommentModel from "models/article/Comment";

function CommentsNumber(props) {
  const [comments, setComments] = useState(props.comments);

  useEffect(() => {
    const read = () =>
      setComments(commentsForArticle(store.getState(), props.articleId));
    read(); // catch dispatches that landed between render and subscribe
    return store.subscribe(read);
  }, []);

  return <>{`${comments.length} comment${comments.length === 1 ? "" : "s"}`}</>;
}

CommentsNumber.propTypes = {
  articleId: PropTypes.number.isRequired,
  comments: PropTypes.arrayOf(PropTypes.instanceOf(CommentModel)).isRequired,
};

export default CommentsNumber;
