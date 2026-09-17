import LocoReactive from "models/LocoReactive";
import RoomRow from "components/user/RoomRow";

class Room extends LocoReactive {
  static name = "Room";

  static components = [RoomRow];

  static attributes = {
    name: {},
    membersCount: {
      type: "Int",
      remoteName: "members_count",
    },
    joined: {
      type: "Boolean",
    },
  };
}

export default Room;
