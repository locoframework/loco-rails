import { Component } from "simplicit";

import { getLoco } from "services/loco";

class User extends Component {
  static name = "admin-user";

  static template = ({ id, email, username, confirmed }) => `
    <tr id="user_${id}" data-component="admin-user" data-key="${id}">
      <td>${email}</td>
      <td>${username}</td>
      <td class="confirmed">${confirmed ? "Yes" : "No"}</td>
      <td>
        <a href="/admin/users/${id}">Show</a> |
        <a href="/admin/users/${id}/edit">Edit</a> |
        <a href="/admin/users/${id}" data-method="delete" data-confirm="Are you sure?">Delete</a> |
        <a href="#" data-ref="ping">Ping</a>
      </td>
    </tr>`;

  connect() {
    this.on("ping", "click", (e) => {
      e.preventDefault();
      getLoco().emit({ type: "PING", user_id: this.model.id });
    });
  }
}

export default User;
