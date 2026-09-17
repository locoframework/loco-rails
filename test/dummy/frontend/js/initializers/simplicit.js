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

// Both run on turbo:load. Scripts are loaded from <head> without `defer`, so
// <body> — and the data-model payload — do not exist yet at module eval; and on
// a first page load Turbo dispatches turbo:load before a DOMContentLoaded
// listener of ours would run, which would let a controller action look for a
// record before anything had hydrated one.
//
// start() puts observers on the document and so must happen once, ahead of the
// first init(): listeners fire in the order they were added, so this one stays
// above.
document.addEventListener(
  "turbo:load",
  () =>
    start({
      root: document,
      models: [Article, Comment, Room, UserModel],
      components: [Flash, LoadMore, RoomChat, RoomMembers],
      // A server-rendered snapshot is authoritative only as of the moment it
      // was rendered, and loading it replaces the collection. Anything that
      // happened after that — a notification handled while the page was still
      // in flight — has to be applied again on top of it.
      onHydrate: (asOf) => getLoco().replaySince(asOf),
    }),
  { once: true },
);

document.addEventListener("turbo:load", () => {
  env = init(Controllers);
});

const getEnv = () => env;

export default getEnv;
