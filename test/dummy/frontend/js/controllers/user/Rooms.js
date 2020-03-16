import { Controllers } from "loco-js";

import Member from "models/room/Member";

import List from "views/user/rooms/List";
import Show from "views/user/rooms/Show";

class Rooms extends Controllers.Base {
  initialize() {}

  index() {
    List();
  }

  async show() {
    const view = new Show({ id: this.params.id });
    this.setView("show", view);
    view.render();
    const resp = await Member.all({ roomId: this.params.id });
    view.renderMembers(resp.resources);
  }
}

export default Rooms;
