import { Controllers } from "loco-js";

import "initializers/rails";
import "initializers/loco";

import "scaffold.css";
import "global.scss";

import Main from "controllers/main.coffee";

Object.assign(Controllers, {
  Main
});
