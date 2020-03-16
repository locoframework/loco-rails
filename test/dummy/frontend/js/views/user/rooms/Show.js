import { emit, subscribe, Views } from "loco-js";

import Room from "models/Room";

let roomId = null;

const memberJoined = member => {
  const li = `<li id='user_${member.id}'>${member.username}</li>`;
  document.getElementById("members").insertAdjacentHTML("beforeend", li);
};

const memberLeft = member => {
  const node = document.querySelector(`#members li#user_${member.id}`);
  node.parentNode.removeChild(node);
};

const receivedSignal = (signal, data) => {
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

class Show extends Views.Base {
  constructor(opts = {}) {
    super(opts);
    roomId = opts.id;
  }

  render() {
    subscribe({ to: Room, with: receivedSignal });
    this._handleSendingMessage();
  }

  renderMembers(members) {
    for (const member of members) {
      memberJoined(member);
    }
  }

  receivedMessage(message, author) {
    const renderedMessage = `<p><b>${author}</b>: ${message}</p>`;
    document
      .getElementById("messages")
      .insertAdjacentHTML("beforeend", renderedMessage);
  }

  _handleSendingMessage() {
    document
      .querySelector("[data-behavior~=room-speaker]")
      .addEventListener("keypress", event => {
        if (event.keyCode !== 13) return;
        event.preventDefault();
        emit({
          signal: "message",
          txt: event.target.value,
          room_id: this.roomId
        });
        event.target.value = "";
      });
  }
}

export default Show;
