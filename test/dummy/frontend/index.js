import { Controllers } from "loco-js";

import "initializers/rails";
import "initializers/loco";

import "scaffold.css";
import "global.scss";

import Admin from "controllers/admin.coffee";
import Main from "controllers/main.coffee";

Object.assign(Controllers, {
  Admin,
  Main
});
