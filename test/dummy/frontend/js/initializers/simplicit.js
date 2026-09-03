import { init, start } from "simplicit";

import Admin from "controllers/Admin";
import Main from "controllers/Main";
import User from "controllers/User";

import Article from "models/Article";
import LoadMore from "components/main/LoadMore";

const Controllers = {
  Admin,
  Main,
  User,
};

// Scripts are loaded from <head> without `defer`, so <body> — and the
// data-model payload — do not exist yet at module eval.
document.addEventListener("DOMContentLoaded", () => {
  start({ root: document, models: [Article], components: [LoadMore] });
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
