import "scaffold.css";
import "global.scss";

import "initializers/rails";
import "initializers/loco";
import "validators";
import "locales";
import "controllers";
import "models";

// for testing purposes only
import { Channels, Env } from "loco-js";
window.test = {
  Channels,
  Env
};
