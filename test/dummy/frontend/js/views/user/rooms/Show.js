import { emit, subscribe } from "loco-js";

import Room from "models/Room";

const memberJoined = member => {
  const li = `<li id='user_${member.id}'>${member.username}</li>`;
  document.getElementById("members").insertAdjacentHTML("beforeend", li);
};

const memberLeft = member => {
  const node = document.querySelector(`#members li#user_${member.id}`);
  node.parentNode.removeChild(node);
};

const createReceivedSignal = roomId => {
  return function(signal, data) {
    switch (signal) {
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

const handleSendingMessage = roomId => {
  document
    .querySelector("[data-behavior~=room-speaker]")
    .addEventListener("keypress", event => {
      if (event.keyCode !== 13) return;
      event.preventDefault();
      emit({
        signal: "message",
        txt: event.target.value,
        room_id: roomId
      });
      event.target.value = "";
    });
};

export default {
  render: roomId => {
    subscribe({ to: Room, with: createReceivedSignal(roomId) });
    handleSendingMessage(roomId);
  },

  renderMembers: members => {
    for (const member of members) {
      memberJoined(member);
    }
  },

  receivedMessage: (message, author) => {
    const renderedMessage = `<p><b>${author}</b>: ${message}</p>`;
    document
      .getElementById("messages")
      .insertAdjacentHTML("beforeend", renderedMessage);
  }
};
