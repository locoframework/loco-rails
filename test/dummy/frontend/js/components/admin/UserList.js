import React from "react";
import PropTypes from "prop-types";

import User from "./User";
import UserModel from "models/user.coffee";

function UserList({ users }) {
  const list = users.map(user => <User key={`user_${user.id}`} user={user} />);

  return <React.Fragment>{list}</React.Fragment>;
}

UserList.propTypes = {
  users: PropTypes.arrayOf(PropTypes.instanceOf(UserModel)).isRequired
};

export default UserList;
