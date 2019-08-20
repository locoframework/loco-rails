import { Controllers } from "loco-js";

import Member from "models/room/Member";

import List from "views/user/rooms/List";
import Show from "views/user/rooms/Show";

class Rooms extends Controllers.Base {
  initialize() {}

  index() {
    new List().render();
  }

  show() {
    const view = new Show({ id: this.params.id });
    this.setView("show", view);
    view.render();
    Member.all({ roomId: this.params.id }).then(resp =>
      view.renderMembers(resp.resources)
    );
  }
}

export default Rooms;
