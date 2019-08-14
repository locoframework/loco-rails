import { Models } from "loco-js";

class Room extends Models.Base {
  static identity = "Room";

  static resources = {};

  static attributes = {};

  static validate = [];

  constructor(data) {
    super(data);
  }
}

export default Room;
