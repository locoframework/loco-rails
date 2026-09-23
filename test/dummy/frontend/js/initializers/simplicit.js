import { init, start } from "simplicit";

import { getLoco } from "services/app";

import Admin from "controllers/Admin";
import Main from "controllers/Main";
import User from "controllers/User";

import Article from "models/Article";
import Comment from "models/article/Comment";
import Room from "models/Room";
import UserModel from "models/User";
import Flash from "components/shared/Flash";
import LoadMore from "components/main/LoadMore";
import RoomChat from "components/user/RoomChat";
import RoomMembers from "components/user/RoomMembers";

const Controllers = {
  Admin,
  Main,
  User,
};

let env = null;

document.addEventListener("turbo:load", () => {
  if (env === null)
    start({
      root: document,
      models: [Article, Comment, Room, UserModel],
      components: [Flash, LoadMore, RoomChat, RoomMembers],
      onHydrate: (asOf) => getLoco().replaySince(asOf),
    });

  env = init(Controllers);
});

const getEnv = () => env;

export default getEnv;
