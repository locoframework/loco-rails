import { Models } from "loco-js";

class Member extends Models.Base {
  static identity = "Room.Member";

  static resources = {
    url: "/user/rooms/:roomId/members",
    paginate: { per: 100 }
  };

  constructor(data) {
    super(data);
  }
}

export default Member;
