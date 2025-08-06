import { init } from "loco-js-core";

import Admin from "controllers/Admin";
import Main from "controllers/Main";
import User from "controllers/User";

const Controllers = {
  Admin,
  Main,
  User,
};

let env = null;

document.addEventListener("turbo:load", () => {
  env = init(Controllers);
});

["turbo:click", "turbo:submit-start"].forEach((event) => {
  document.addEventListener(event, () => {
    if (env !== null && env.controller.cleanup != null) {
      env.controller.cleanup();
      env.controller.cleanup = null;
    }
  });
});

const getEnv = () => env;

export default getEnv;
