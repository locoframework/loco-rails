import { Component } from "simplicit";

import DateService from "services/Date";

class Comment extends Component {
  static name = "admin-comment";

  static template = ({ id, articleId, author, text, createdAt }) => `
    <p id="comment_${id}" data-component="admin-comment" data-key="${id}">
      <b>${author}</b> on <i>${new DateService(createdAt).strftime("%d %b %y")}</i>
      (<a href="/admin/articles/${articleId}/comments/${id}/edit">edit</a>)
      <br />
      ${text}
    </p>`;
}

export default Comment;
