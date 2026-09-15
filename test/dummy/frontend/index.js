import "scaffold.css";
import "global.css";

import "initializers/turbo-rails";
import "initializers/simplicit";
import "initializers/loco";
import "validators/Vulgarity";
import "locales";

import { getLoco } from "services/loco";

// for testing purposes only
window.test = {
  getLine: () => getLoco().getLine(),
  getWire: () => getLoco().getWire(),
};
