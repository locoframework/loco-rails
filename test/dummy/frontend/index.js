import "scaffold.css";
import "global.css";

import "initializers/rails";
import "initializers/loco";
import "validators";
import "locales";
import "controllers";
import "models";

// for testing purposes only
import { getWire, Channels } from "loco-js";
window.test = {
  getWire,
  Channels
};
