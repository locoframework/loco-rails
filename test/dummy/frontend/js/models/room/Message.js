import { Models } from "loco-js-model";

export default class Message extends Models.Base {
  static identity = "Room.Message";

  static resources = {
    url: "/user/rooms/:roomId/messages",
  };
}
