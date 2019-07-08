import React from "react";
import PropTypes from "prop-types";

import User from "./User";
import UserModel from "models/user.coffee";

function UserList(props) {
  const users = props.users.map(user => (
    <User key={`user_${user.id}`} user={user} />
  ));

  return <React.Fragment>{users}</React.Fragment>;
}

UserList.propTypes = {
  users: PropTypes.arrayOf(PropTypes.instanceOf(UserModel)).isRequired,
  order: PropTypes.string.isRequired
};

export default UserList;
