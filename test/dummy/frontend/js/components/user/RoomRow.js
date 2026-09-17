import { Component } from "simplicit";

class RoomRow extends Component {
  static name = "room-row";

  static template = ({ id, name, membersCount, joined }) => `
    <tr id="room_${id}" data-component="room-row" data-key="${id}">
      <td>${name}</td>
      <td class="members">${membersCount}</td>
      <td>
        <a rel="nofollow" data-turbo-method="patch"
          href="${joined ? `/user/rooms/${id}/leave` : `/user/rooms/${id}/join`}"
          >${joined ? "Leave" : "Join"}</a
        >
        |
        <a rel="nofollow" data-turbo-method="delete" data-turbo-confirm="R U sure?"
          href="/user/rooms/${id}"
          >Destroy</a
        >
      </td>
    </tr>`;
}

export default RoomRow;
