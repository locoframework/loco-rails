import { Config } from "loco-js-model";

class Base {
  setScope(name) {
    Config.scope = name;
  }
}

export default Base;
