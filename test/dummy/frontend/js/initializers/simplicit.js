import { init, start } from "simplicit";

import { getLoco } from "services/loco";

import Admin from "controllers/Admin";
import Main from "controllers/Main";
import User from "controllers/User";

import Article from "models/Article";
import Comment from "models/article/Comment";
import UserModel from "models/User";
import LoadMore from "components/main/LoadMore";

const Controllers = {
  Admin,
  Main,
  User,
};

// Scripts are loaded from <head> without `defer`, so <body> — and the
// data-model payload — do not exist yet at module eval.
document.addEventListener("DOMContentLoaded", () => {
  start({
    root: document,
    models: [Article, Comment, UserModel],
    components: [LoadMore],
    // A server-rendered snapshot is authoritative only as of the moment it was
    // rendered, and loading it replaces the collection. Anything that happened
    // after that — a notification handled while the page was still in flight —
    // has to be applied again on top of it.
    onHydrate: (asOf) => getLoco().replaySince(asOf),
  });
});

let env = null;

document.addEventListener("turbo:load", () => {
  env = init(Controllers);
});

["turbo:click", "turbo:submit-start"].forEach((event) => {
  document.addEventListener(event, () => {
    if (env?.controller?.cleanup != null) {
      env.controller.cleanup();
      env.controller.cleanup = null;
    }
  });
});

const getEnv = () => env;

export default getEnv;
