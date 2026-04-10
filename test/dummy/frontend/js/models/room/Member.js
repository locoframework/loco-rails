import { Models } from "loco-js-model";

class Member extends Models.Base {
  static identity = "Room.Member";

  static resources = {
    url: "/user/rooms/:roomId/members",
    paginate: { per: 100 },
  };
}

export default Member;
