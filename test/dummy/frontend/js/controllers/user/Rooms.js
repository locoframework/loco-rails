import { Controllers } from "loco-js";

import Member from "models/room/Member";

import List from "views/user/rooms/List";
import Show, { renderMembers, receivedMessage } from "views/user/rooms/Show";

class Rooms extends Controllers.Base {
  constructor() {
    super();
    this.callbacks = {};
  }

  index() {
    List();
  }

  async show() {
    this.callbacks["receivedMessage"] = receivedMessage;
    Show(this.params.id);
    const resp = await Member.all({ roomId: this.params.id });
    renderMembers(resp.resources);
  }
}

export default Rooms;
