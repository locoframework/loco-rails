import { Controllers } from "loco-js";

import Articles from "./main/Articles";
import Pages from "./main/Pages";
import Users from "./main/Users";

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
