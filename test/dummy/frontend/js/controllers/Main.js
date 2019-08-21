import { Controllers } from "loco-js";

import Disconnection from "./concerns/Disconnection";
import Articles from "./main/Articles";
import Pages from "./main/Pages";
import Users from "./main/Users";

Object.assign(Controllers.Base.prototype, Disconnection);

class Main extends Controllers.Base {
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
