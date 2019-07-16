import React from "react";
import PropTypes from "prop-types";
import { Services } from "loco-js";

import CommentModel from "models/article/comment.coffee";

function Comment({ comment }) {
  const createdAt = new Services.Date(comment.createdAt).strftime("%d %b %y");

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
