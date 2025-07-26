import { subscribe } from "loco-js";

import Room from "models/Room";

const store = {
  currentUser: null,
  rooms: [],
};

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
  const tbody = document.querySelector("#rooms_list tbody");
  store.rooms.forEach(r => {
    tbody.insertAdjacentHTML(
      "beforeend",
      roomTmpl(r)
    );
  });
}

const reRenderRoom = (roomId) => {
  const room = store.rooms.find(r => r.id === roomId);
  const node = document.getElementById(`room_${roomId}`);
  node.innerHTML = roomTmpl(room);
};

const receivedMessage = (type, data) => {
  switch (type) {
    case "Room member_joined": {
      const room = store.rooms.find(r => r.id === data.room_id);
      room.members_count++;
      if (data.member.id === store.currentUser.id) {
        room.joined = true;
      }
      reRenderRoom(data.room_id);
      break;
    }
    case "Room member_left": {
      const room = store.rooms.find(r => r.id === data.room_id);
      room.members_count--;
      if (data.member.id === store.currentUser.id) {
        room.joined = false;
      }
      reRenderRoom(data.room_id);
      break;
    }
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

export default function () {
  let dataEl = document.getElementById("rooms-data");
  store.rooms = JSON.parse(dataEl.textContent);
  renderRooms();

  dataEl = document.getElementById("current-user-data");
  store.currentUser = JSON.parse(dataEl.textContent);

  return subscribe({ to: Room, with: receivedMessage });
}
