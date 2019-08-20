import { Controllers, Mix } from "loco-js";

import Disconnection from "./concerns/Disconnection";
import Articles from "./main/Articles";
import Pages from "./main/Pages";
import Users from "./main/Users";

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
