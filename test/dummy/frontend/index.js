import { Controllers, Models } from "loco-js";

import "initializers/rails";
import "initializers/loco";

import "scaffold.css";
import "global.scss";

import Admin from "controllers/Admin";
import Main from "controllers/Main";

import CustomModels from "models";

Object.assign(Models, CustomModels);

Object.assign(Controllers, {
  Admin,
  Main
});
