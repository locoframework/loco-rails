import { Component } from "simplicit";

class UserShow extends Component {
  static name = "admin-user-show";

  static template = ({ id, email, username, confirmed }) => `
    <div data-component="admin-user-show" data-key="${id}">
      <p>
        <strong>Email:</strong>
        <span id="user_email">${email}</span>
      </p>

      <p>
        <strong>Username:</strong>
        <span id="user_username">${username}</span>
      </p>

      <p>
        <strong>Confirmed:</strong>
        <span id="user_confirmed">${confirmed ? "Yes" : "No"}</span>
      </p>
    </div>`;
}

export default UserShow;
