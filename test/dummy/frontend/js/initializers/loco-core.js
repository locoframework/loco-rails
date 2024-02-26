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

["DOMContentLoaded", "turbo:load"].forEach((eventName) => {
  document.addEventListener(eventName, () => {
    env = init(Controllers);
  });
});

const getEnv = () => env;

export default getEnv;
