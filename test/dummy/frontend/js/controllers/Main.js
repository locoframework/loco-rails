import { Controllers, Mix } from "loco-js";

import Disconnection from "./concerns/disconnection.coffee";
import Articles from "./main/articles.coffee";
import Pages from "./main/Pages";
import Users from "./main/users.coffee";

class Main extends Mix(Controllers.Base, Disconnection) {
  initialize() {
    this.setScope("main");
  }
}

Object.assign(Main, {
  Articles,
  Pages,
  Users
});

export default Main;
