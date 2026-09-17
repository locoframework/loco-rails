import Room from "models/Room";
import CurrentUser from "services/CurrentUser";

const membersChanged = (roomId, change, memberId) => {
  const room = Room.byId(roomId);
  if (!room) return;

  const changes = { membersCount: room.membersCount + change };
  if (memberId === CurrentUser().id) changes.joined = change > 0;
  room.update(changes);
};

export const created = ({ room }) => {
  Room.add({ ...room, members_count: 0, joined: false });
};

export const destroyed = ({ room_id: roomId }) => {
  Room.byId(roomId)?.del();
};

export const memberJoined = ({ room_id: roomId, member }) => {
  membersChanged(roomId, 1, member.id);
};

export const memberLeft = ({ room_id: roomId, member }) => {
  membersChanged(roomId, -1, member.id);
};
