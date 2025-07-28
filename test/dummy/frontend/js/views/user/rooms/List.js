import { subscribe } from "loco-js";

import Room from "models/Room";
import CurrentUser from "services/CurrentUser";

let rooms = [];

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

const renderRooms = () => {
  rooms.forEach(r => renderRoom(r));
}

const renderRoom = (room) => {
  const tbody = document.querySelector("#rooms_list tbody");
  tbody.insertAdjacentHTML("beforeend", roomTmpl(room));
}

const reRenderRoom = (roomId) => {
  const room = rooms.find(r => r.id === roomId);
  const node = document.getElementById(`room_${roomId}`);
  node.innerHTML = roomTmpl(room);
};

const membersChanged = (roomId, change, memberId) => {
  const room = rooms.find(r => r.id === roomId);
  room.members_count += change;
  if (memberId === CurrentUser().id) {
    room.joined = change > 0;
  }
  reRenderRoom(roomId);
}

const receivedMessage = (type, data) => {
  switch (type) {
    case "Room member_joined": {
      membersChanged(data.room_id, 1, data.member.id);
      break;
    }
    case "Room member_left": {
      membersChanged(data.room_id, -1, data.member.id);
      break;
    }
    case "Room created": {
      rooms.push(data.room);
      renderRoom(data.room);
      break;
    }
    case "Room destroyed": {
      const roomNode = document.getElementById(`room_${data.room_id}`);
      roomNode.parentNode.removeChild(roomNode);
    }
  }
};

export default function () {
  let dataEl = document.getElementById("rooms-data");
  rooms = JSON.parse(dataEl.textContent);
  renderRooms();

  return subscribe({ to: Room, with: receivedMessage });
}
