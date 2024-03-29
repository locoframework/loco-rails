import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "store";
import User from "components/admin/User";
import UserModel from "models/User";

function UserList(props) {
  const [users, setUsers] = useState(props.users);

  useEffect(() => {
    const unsubscribe = store.subscribe(() => setUsers(store.getState().users));

    return () => {
      unsubscribe();
    };
  }, []);

  const list = users.map((user) => (
    <User key={`user_${user.id}`} user={user} />
  ));

  return <>{list}</>;
}

UserList.propTypes = {
  users: PropTypes.arrayOf(PropTypes.instanceOf(UserModel)).isRequired,
};

export default UserList;
