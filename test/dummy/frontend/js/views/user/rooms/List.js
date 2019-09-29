import { Views } from "loco-js";

import Room from "models/User";

class List extends Views.Base {
  constructor(opts = {}) {
    super(opts);
  }

  render() {
    this.connectWith(Room);
  }

  receivedSignal(signal, data) {
    switch (signal) {
      case "Room member_joined":
        this._memberJoined(data.room_id);
        break;
      case "Room member_left":
        this._memberLeft(data.room_id);
        break;
      case "Room created": {
        const renderedRoom = this._renderRoom(data.room);
        document
          .getElementById("rooms_list")
          .insertAdjacentHTML("beforeend", renderedRoom);
        break;
      }
      case "Room destroyed": {
        const roomNode = document.getElementById(`room_${data.room_id}`);
        roomNode.parentNode.removeChild(roomNode);
      }
    }
  }

  _memberJoined(roomId) {
    const node = this._membersNode(roomId);
    node.textContent = parseInt(node.text()) + 1;
  }

  _memberLeft(roomId) {
    const node = this._membersNode(roomId);
    node.textContent = parseInt(node.text()) - 1;
  }

  _membersNode(roomId) {
    document.querySelector(`#room_${roomId} td.members`);
  }

  _renderRoom(room) {
    `
    <tr id='room_${room.id}'>
      <td>${room.name}</td>
      <td class='members'>0</td>
      <td>
        <a rel='nofollow' data-method='patch' href='/user/rooms/${room.id}/join'>Join</a> |
        <a data-confirm='R U sure?' rel='nofollow' data-method='delete'
          href='/user/rooms/${room.id}'>Destroy</a>
      </td>
    </tr>
    `;
  }
}

export default List;
