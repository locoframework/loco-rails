import React from "react";
import PropTypes from "prop-types";

import UserModel from "models/user.coffee";

function User(props) {
  const user = props.user;

  return <tr id={`user_${user.id}`} />;
}

User.propTypes = {
  user: PropTypes.instanceOf(UserModel).isRequired
};

export default User;
