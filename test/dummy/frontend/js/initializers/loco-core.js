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

document.addEventListener("DOMContentLoaded", function() {
  env = init(Controllers);
});

const getEnv = () => env;

export default getEnv;
