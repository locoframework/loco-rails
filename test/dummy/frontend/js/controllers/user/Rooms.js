import { helpers } from "loco-js-core";

import Member from "models/room/Member";

import List from "views/user/rooms/List";
import Show from "views/user/rooms/Show";

class Rooms {
  constructor() {
    this.view = null;
    this.unsubscribe = null;
  }

  deinitialize() {
    if (this.unsubscribe !== null) {
      this.unsubscribe();
      this.unsubscribe = null;
    }
  }

  index() {
    this.unsubscribe = List();
  }

  async show() {
    this.view = Show;
    this.unsubscribe = Show.render(helpers.params.id);
    const resp = await Member.all({ roomId: helpers.params.id });
    Show.renderMembers(resp.resources);
  }
}

export default Rooms;
