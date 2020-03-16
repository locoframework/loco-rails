import { subscribe, Views } from "loco-js";

import Room from "models/User";

const memberJoined = roomId => {
  const node = membersNode(roomId);
  node.textContent = parseInt(node.text()) + 1;
};

const memberLeft = roomId => {
  const node = membersNode(roomId);
  node.textContent = parseInt(node.text()) - 1;
};

const membersNode = roomId => {
  document.querySelector(`#room_${roomId} td.members`);
};

const renderRoom = room => {
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
};

const receivedSignal = (signal, data) => {
  switch (signal) {
    case "Room member_joined":
      memberJoined(data.room_id);
      break;
    case "Room member_left":
      memberLeft(data.room_id);
      break;
    case "Room created": {
      const renderedRoom = renderRoom(data.room);
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
};

class List extends Views.Base {
  constructor(opts = {}) {
    super(opts);
  }

  render() {
    subscribe({ to: Room, with: receivedSignal });
  }
}

export default List;
