import { Component } from "simplicit";

import DateService from "services/Date";

class Comment extends Component {
  static name = "user-comment";

  static template = ({ id, author, text, createdAt }) => `
    <p id="comment_${id}" data-component="user-comment" data-key="${id}">
      <b>${author}</b> on <i>${new DateService(createdAt).strftime("%d %b %y")}</i>
      <br />
      ${text}
    </p>`;
}

export default Comment;
