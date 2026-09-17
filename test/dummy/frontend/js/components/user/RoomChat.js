import { Component, helpers } from "simplicit";

import { getLoco, renderFlash } from "services/app";

const DISCONNECTED =
  "You have been disconnected from the server. You might have lost some ephemeral messages.";

class RoomChat extends Component {
  static name = "room-chat";

  connect() {
    this.roomId = helpers.params.id;
    this.on("speaker", "keypress", (e) => this.#send(e));
    this.interval(
      () => getLoco().emit({ type: "HEARTBEAT", room_id: this.roomId }),
      3000,
    );
  }

  #send(e) {
    if (e.keyCode !== 13) return;
    e.preventDefault();
    getLoco().emit({
      type: "NEW_MESSAGE",
      txt: e.target.value,
      room_id: this.roomId,
      message_type: document.querySelector("[name='message_type']:checked")
        .value,
    });
    e.target.value = "";
  }

  receivedMessage(message, author) {
    this.ref("messages").insertAdjacentHTML(
      "beforeend",
      `<p class="msg"><b>${author}</b>: ${message}</p>`,
    );
  }

  disconnected() {
    renderFlash({ alert: DISCONNECTED });
  }
}

export default RoomChat;
