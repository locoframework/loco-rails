import React from "react";
import PropTypes from "prop-types";

import CommentModel from "models/article/Comment";
import Comment from "components/admin/comment";

function CommentList({ comments }) {
  if (comments.length === 0) {
    return <p>No comments</p>;
  }
  return (
    <>
      {comments.map((comment) => (
        <Comment comment={comment} key={comment.id} />
      ))}
    </>
  );
}

CommentList.propTypes = {
  comments: PropTypes.arrayOf(PropTypes.instanceOf(CommentModel)).isRequired,
};

export default CommentList;
