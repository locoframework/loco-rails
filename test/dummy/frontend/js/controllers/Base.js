import { Config } from "loco-js-model";

export default class Base {
  setScope(name) {
    Config.scope = name;
  }
}
