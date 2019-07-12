import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "stores/admin";
import UserList from "components/admin/UserList";
import UserModel from "models/user.coffee";

function UserListWrapper(props) {
  const [users, setUsers] = useState(props.users);

  useEffect(() => {
    const unsubscribe = store.subscribe(() => setUsers(store.getState().users));

    return () => {
      unsubscribe();
    };
  });

  return <UserList users={users} />;
}

UserListWrapper.propTypes = {
  users: PropTypes.arrayOf(PropTypes.instanceOf(UserModel)).isRequired
};

export default UserListWrapper;
