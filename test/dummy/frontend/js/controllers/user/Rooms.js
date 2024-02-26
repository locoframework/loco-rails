import { helpers } from "loco-js-core";

import Member from "models/room/Member";

import List from "views/user/rooms/List";
import Show from "views/user/rooms/Show";

class Rooms {
  constructor() {
    this.callbacks = {};
  }

  index() {
    this.cleanup = List();
  }

  async show() {
    this.callbacks["receivedMessage"] = Show.receivedMessage;
    this.cleanup = Show.render(helpers.params.id);
    const resp = await Member.all({ roomId: helpers.params.id });
    Show.renderMembers(resp.resources);
  }
}

export default Rooms;
