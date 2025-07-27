import { subscribe } from "loco-js";

import loco from "initializers/loco";
import Room from "models/Room";

const memberJoined = (member) => {
  if (document.querySelector(`#members li#user_${member.id}`)) {
    return;
  }
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
        message_type: document.querySelector("[name='message_type']:checked").value,
      });
      event.target.value = "";
    });
};

const heartbeat = (roomId) => {
  const intervalId = setInterval(() => {
    loco.emit({ type: "HEARTBEAT", room_id: roomId });
    console.log("heartbeat", roomId); // TODO: remove
  }, 3000);
  return () => clearInterval(intervalId);
};

export default {
  render: (roomId) => {
    handleSendingMessage(roomId);
    const unsubscribeHeartbeat = heartbeat(roomId);
    const unsubscribeMessages = subscribe({ to: Room, with: createReceivedMessage(roomId) });
    return () => {
      unsubscribeHeartbeat();
      unsubscribeMessages();
    };
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
