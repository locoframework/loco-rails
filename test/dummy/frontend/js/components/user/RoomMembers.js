import { subscribe } from "loco-js";
import { Component, helpers } from "simplicit";

import Member from "models/room/Member";
import Room from "models/Room";

class RoomMembers extends Component {
  static name = "room-members";

  static template = ({ members }) => `
    <ul id="members" class="bottom-space" data-component="room-members">
      ${members
        .map(
          (m) => `<li id="user_${m.id}" data-key="${m.id}">${m.username}</li>`,
        )
        .join("")}
    </ul>`;

  async connect() {
    this.roomId = helpers.params.id;
    // Not for the paint — the server already sent an empty <ul>. It is the
    // shape: a member can join while the fetch below is still in flight, and
    // the handlers read this.props.members.
    this.update({ members: [] });
    this.registerCleanup(
      subscribe({
        to: Room,
        with: (...args) => this.#receivedMessage(...args),
      }),
    );
    const resp = await Member.all({ roomId: this.roomId });
    this.update({ members: resp.resources });
  }

  #receivedMessage(type, payload) {
    if (payload.room_id !== this.roomId) return;

    switch (type) {
      case "Room member_joined":
        this.#add(payload.member);
        break;
      case "Room member_left":
        this.update({
          members: this.props.members.filter((m) => m.id !== payload.member.id),
        });
    }
  }

  #add(member) {
    if (this.props.members.some((m) => m.id === member.id)) return;
    this.update({ members: [...this.props.members, member] });
  }
}

export default RoomMembers;
