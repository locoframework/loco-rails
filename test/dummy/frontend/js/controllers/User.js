import App from "./App";
import Articles from "./user/Articles";
import Rooms from "./user/Rooms";

class User extends App {}

Object.assign(User, {
  Articles,
  Rooms
});

export default User;
