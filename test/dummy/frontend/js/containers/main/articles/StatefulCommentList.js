import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "stores/main";
import Comment from "components/main/Comment";
import CommentModel from "models/article/comment.coffee";

function StatefulCommentList(props) {
  const [comments, setComments] = useState(props.comments);

  useEffect(() => {
    const unsubscribe = store.subscribe(() =>
      setComments(store.getState().comments)
    );

    return () => {
      unsubscribe();
    };
  });

  const list = comments.map(comment => (
    <Comment key={comment.id} comment={comment} />
  ));

  return <>{list}</>;
}

StatefulCommentList.propTypes = {
  comments: PropTypes.arrayOf(PropTypes.instanceOf(CommentModel)).isRequired
};

export default StatefulCommentList;
