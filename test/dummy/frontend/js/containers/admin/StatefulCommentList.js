import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "stores/admin";
import CommentModel from "models/article/comment.coffee";
import Comment from "components/admin/comment";

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

  if (comments.length === 0) {
    return <p>No comments</p>;
  }

  return (
    <>
      {comments.map(comment => (
        <Comment comment={comment} key={comment.id} />
      ))}
    </>
  );
}

StatefulCommentList.propTypes = {
  comments: PropTypes.arrayOf(PropTypes.instanceOf(CommentModel)).isRequired
};

export default StatefulCommentList;
