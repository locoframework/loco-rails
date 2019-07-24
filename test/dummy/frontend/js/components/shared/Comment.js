import React from "react";
import PropTypes from "prop-types";
import { Services } from "loco-js";

import CommentModel from "models/article/comment.coffee";

function Comment({ comment, isAdmin = false }) {
  const createdAt = new Services.Date(comment.createdAt).strftime("%d %b %y");

  const adminSection = () => {
    let approveLink;

    if (comment.approved) {
      approveLink =
        (
          <a
            href={`/user/articles/${comment.articleId}/comments/${
              comment.id
            }/approve`}
            className="approve"
          >
            approve
          </a>
        ) + " | ";
    }

    return (
      <>
        {approveLink}
        <a
          href={`/user/articles/${comment.articleId}/comments/${
            comment.id
          }/edit`}
        >
          edit
        </a>{" "}
        |
        <a
          href={`/user/articles/${comment.articleId}/comments/${comment.id}`}
          data-method="delete"
          data-confirm="Are you sure?"
        >
          delete
        </a>
      </>
    );
  };

  return (
    <p id={`comment_${comment.id}`} data-id={comment.id}>
      <b>{comment.author}</b> on <i>{createdAt}</i>
      {isAdmin ? `(${adminSection()})` : ""}
      <br />
      {comment.text}
    </p>
  );
}

Comment.propTypes = {
  comment: PropTypes.instanceOf(CommentModel).isRequired,
  isAdmin: PropTypes.bool
};

export default Comment;
