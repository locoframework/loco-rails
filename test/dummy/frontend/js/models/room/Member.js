import { Models } from "loco-js-model";

export default class Member extends Models.Base {
  static identity = "Room.Member";

  static resources = {
    url: "/user/rooms/:roomId/members",
  };
}
