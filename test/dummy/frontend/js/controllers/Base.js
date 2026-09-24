import { Config } from "loco-js-model";

export default class Base {
  deinitialize() {
    this.unsubscribe?.();
    this.unsubscribe = null;
  }

  setScope(name) {
    Config.scope = name;
  }
}
