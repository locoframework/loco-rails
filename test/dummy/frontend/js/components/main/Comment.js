import React from "react";
import PropTypes from "prop-types";
import DateService from "services/Date";

import CommentModel from "models/article/Comment";

function Comment({ comment }) {
  const createdAt = new DateService(comment.createdAt).strftime("%d %b %y");

  return (
    <p id={`comment_${comment.id}`}>
      <b>{comment.author}</b> on <i>{createdAt}</i> wrote:
      <br />
      {comment.text}
    </p>
  );
}

Comment.propTypes = {
  comment: PropTypes.instanceOf(CommentModel).isRequired
};

export default Comment;
