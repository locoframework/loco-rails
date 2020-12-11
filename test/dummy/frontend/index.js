import "scaffold.css";
import "global.css";

import "initializers/rails";
import "initializers/loco";
import "validators";
import "locales";
import "controllers";

// for testing purposes only
import { getLine, getWire } from "loco-js";
window.test = {
  getLine,
  getWire
};
