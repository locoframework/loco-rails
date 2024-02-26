import { subscribe } from "loco-js";

import loco from "initializers/loco";
import Room from "models/Room";

const memberJoined = (member) => {
  const li = `<li id='user_${member.id}'>${member.username}</li>`;
  document.getElementById("members").insertAdjacentHTML("beforeend", li);
};

const memberLeft = (member) => {
  const node = document.querySelector(`#members li#user_${member.id}`);
  node.parentNode.removeChild(node);
};

const createReceivedMessage = (roomId) => {
  return function (type, data) {
    switch (type) {
      case "Room member_joined":
        if (data.room_id !== roomId) return;
        memberJoined(data.member);
        break;
      case "Room member_left":
        if (data.room_id !== roomId) return;
        memberLeft(data.member);
    }
  };
};

const handleSendingMessage = (roomId) => {
  document
    .querySelector("[data-behavior~=room-speaker]")
    .addEventListener("keypress", (event) => {
      if (event.keyCode !== 13) return;
      event.preventDefault();
      loco.emit({
        type: "NEW_MESSAGE",
        txt: event.target.value,
        room_id: roomId,
      });
      event.target.value = "";
    });
};

export default {
  render: (roomId) => {
    handleSendingMessage(roomId);
    return subscribe({ to: Room, with: createReceivedMessage(roomId) });
  },

  renderMembers: (members) => {
    for (const member of members) {
      memberJoined(member);
    }
  },

  receivedMessage: (message, author) => {
    const renderedMessage = `<p class="msg"><b>${author}</b>: ${message}</p>`;
    document
      .getElementById("messages")
      .insertAdjacentHTML("beforeend", renderedMessage);
  },
};
