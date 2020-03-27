import { helpers, Controllers } from "loco-js";

import Member from "models/room/Member";

import List from "views/user/rooms/List";
import Show from "views/user/rooms/Show";

class Rooms extends Controllers.Base {
  constructor() {
    super();
    this.callbacks = {};
  }

  index() {
    List();
  }

  async show() {
    this.callbacks["receivedMessage"] = Show.receivedMessage;
    Show.render(helpers.params.id);
    const resp = await Member.all({ roomId: helpers.params.id });
    Show.renderMembers(resp.resources);
  }
}

export default Rooms;
