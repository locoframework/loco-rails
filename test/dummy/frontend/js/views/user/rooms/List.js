import { subscribe } from "loco-js";

import Room from "models/Room";

const memberJoined = (roomId) => {
  const node = membersNode(roomId);
  node.textContent = parseInt(node.textContent) + 1;
};

const memberLeft = (roomId) => {
  const node = membersNode(roomId);
  node.textContent = parseInt(node.textContent) - 1;
};

const membersNode = (roomId) => document.querySelector(`#room_${roomId} td.members`);

const roomTmpl = ({ id, name, members_count, joined }) => {
  return `
  <tr id="room_${id}">
    <td>${name}</td>
    <td class="members">${members_count}</td>
    <td>
      <a
        rel="nofollow"
        data-method="patch"
        href="${joined ? `/user/rooms/${id}/leave` : `/user/rooms/${id}/join`}"
      >
        ${joined ? 'Leave' : 'Join'}
      </a>
      |
      <a
        rel="nofollow"
        data-method="delete"
        data-confirm="R U sure?"
        href="/user/rooms/${id}"
      >
        Destroy
      </a>
    </td>
  </tr>
  `;
};

const receivedMessage = (type, data) => {
  switch (type) {
    case "Room member_joined":
      memberJoined(data.room_id);
      break;
    case "Room member_left":
      memberLeft(data.room_id);
      break;
    case "Room created": {
      document
        .querySelector("#rooms_list tbody")
        .insertAdjacentHTML("beforeend", roomTmpl(data.room));
      break;
    }
    case "Room destroyed": {
      const roomNode = document.getElementById(`room_${data.room_id}`);
      roomNode.parentNode.removeChild(roomNode);
    }
  }
};

const renderRooms = () => {
  const dataEl = document.getElementById("rooms-data");
  const rooms = JSON.parse(dataEl.textContent);

  const tbody = document.querySelector("#rooms_list tbody");
  rooms.forEach(r => {
    tbody.insertAdjacentHTML(
      "beforeend",
      roomTmpl(r)
    );
  });
}

export default function () {
  renderRooms();

  return subscribe({ to: Room, with: receivedMessage });
}
