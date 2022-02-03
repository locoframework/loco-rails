import "scaffold.css";
import "global.css";

import "initializers/rails";
import loco from "initializers/loco";
import "validators/Vulgarity";
import "locales";

// for testing purposes only
window.test = {
  getLine: () => loco.getLine(),
  getWire: () => loco.getWire(),
};
