import React, { useState } from "react";
import PropTypes from "prop-types";
import { Services } from "loco-js";

import store from "stores/user";

import CommentModel from "models/article/Comment";

function Comment({ comment, isAdmin = false }) {
  const [approving, setApproving] = useState(false);

  const createdAt = new Services.Date(comment.createdAt).strftime("%d %b %y");

  const handleApproving = e => {
    e.preventDefault();
    setApproving(true);
    comment.approved = true;
    comment.updateAttribute("approved").then(res => {
      if (!res.ok) return;
      store.dispatch({
        type: "UPDATE_COMMENT",
        payload: {
          articleId: comment.articleId,
          comment: new CommentModel({ ...comment, approved: true })
        }
      });
    });
  };

  const adminSection = () => {
    let approveLink;

    if (comment.approved) {
      approveLink = (
        <>
          <span>approved</span> |{" "}
        </>
      );
    } else if (approving) {
      approveLink = (
        <>
          <span>approving...</span> |{" "}
        </>
      );
    } else {
      approveLink = (
        <>
          <a
            href={`/user/articles/${comment.articleId}/comments/${
              comment.id
            }/approve`}
            className="approve"
            onClick={handleApproving}
          >
            approve
          </a>{" "}
          |{" "}
        </>
      );
    }

    return (
      <>
        {" "}
        ({approveLink}
        <a
          href={`/user/articles/${comment.articleId}/comments/${
            comment.id
          }/edit`}
        >
          edit
        </a>{" "}
        |{" "}
        <a
          href={`/user/articles/${comment.articleId}/comments/${comment.id}`}
          data-method="delete"
          data-confirm="Are you sure?"
        >
          delete
        </a>
        )
      </>
    );
  };

  return (
    <p id={`comment_${comment.id}`}>
      <b>{comment.author}</b> on <i>{createdAt}</i>
      {isAdmin ? adminSection() : ""}
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
