import { Component } from "simplicit";

import DateService from "services/Date";

class CommentAdmin extends Component {
  static name = "user-comment-admin";

  static approveLink = ({ approved, approving, url }) => {
    if (approved) return "<span>approved</span>";
    if (approving) return "<span>approving...</span>";
    return `<a href="${url}/approve" class="approve" data-ref="approve">approve</a>`;
  };

  static template = ({
    id,
    articleId,
    author,
    text,
    createdAt,
    approved,
    approving,
  }) => {
    const url = `/user/articles/${articleId}/comments/${id}`;
    return `
    <p id="comment_${id}" data-component="user-comment-admin" data-key="${id}">
      <b>${author}</b> on <i>${new DateService(createdAt).strftime("%d %b %y")}</i>
      (${CommentAdmin.approveLink({ approved, approving, url })} |
      <a href="${url}/edit">edit</a> |
      <a href="${url}" data-method="delete" data-confirm="Are you sure?">delete</a>)
      <br />
      ${text}
    </p>`;
  };

  connect() {
    this.on("approve", "click", (e) => {
      e.preventDefault();
      this.update({ approving: true });
      this.model.updateAttribute("approved", true);
    });
  }
}

export default CommentAdmin;
