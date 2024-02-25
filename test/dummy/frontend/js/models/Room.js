import { Models } from "loco-js-model";

class Room extends Models.Base {
  static identity = "Room";

  constructor(data) {
    super(data);
  }
}

export default Room;
