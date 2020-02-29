import { emit, Views } from "loco-js";

import Room from "models/Room";

class Show extends Views.Base {
  constructor(opts = {}) {
    super(opts);
    this.roomId = opts.id;
  }

  render() {
    this.connectWith(Room);
    this._handleSendingMessage();
  }

  renderMembers(members) {
    for (const member of members) {
      this._memberJoined(member);
    }
  }

  receivedMessage(message, author) {
    const renderedMessage = `<p><b>${author}</b>: ${message}</p>`;
    document
      .getElementById("messages")
      .insertAdjacentHTML("beforeend", renderedMessage);
  }

  receivedSignal(signal, data) {
    switch (signal) {
      case "Room member_joined":
        if (data.room_id !== this.roomId) return;
        this._memberJoined(data.member);
        break;
      case "Room member_left":
        if (data.room_id !== this.roomId) return;
        this._memberLeft(data.member);
    }
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

  _memberJoined(member) {
    const li = `<li id='user_${member.id}'>${member.username}</li>`;
    document.getElementById("members").insertAdjacentHTML("beforeend", li);
  }

  _memberLeft(member) {
    const node = document.querySelector(`#members li#user_${member.id}`);
    node.parentNode.removeChild(node);
  }
}

export default Show;
