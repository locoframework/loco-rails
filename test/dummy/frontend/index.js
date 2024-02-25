import "core-js/stable";

import "scaffold.css";
import "global.css";

import "initializers/rails";
import "initializers/loco-core";
import loco from "initializers/loco";
import "initializers/loco-ui";
import "validators/Vulgarity";
import "locales";

// for testing purposes only
window.test = {
  getLine: () => loco.getLine(),
  getWire: () => loco.getWire(),
};
