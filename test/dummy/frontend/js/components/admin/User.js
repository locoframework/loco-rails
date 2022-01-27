import React from "react";
import PropTypes from "prop-types";

import loco from "initializers/loco";
import UserModel from "models/User";

const User = ({ user }) => {
  const ping = (e, userId) => {
    e.preventDefault();
    loco.emit({ type: "PING", user_id: userId });
  };

  return (
    <tr id={`user_${user.id}`}>
      <td>{user.email}</td>
      <td>{user.username}</td>
      <td className="confirmed">{user.confirmed ? "Yes" : "No"}</td>
      <td>
        <a href={`/admin/users/${user.id}`}>Show</a> |{" "}
        <a href={`/admin/users/${user.id}/edit`}>Edit</a> |{" "}
        <a
          href={`/admin/users/${user.id}`}
          data-method="delete"
          data-confirm="Are you sure?"
        >
          Delete
        </a>{" "}
        |{" "}
        <a href="#" onClick={(e) => ping(e, user.id)}>
          Ping
        </a>
      </td>
    </tr>
  );
};

User.propTypes = {
  user: PropTypes.instanceOf(UserModel).isRequired,
};

export default User;
