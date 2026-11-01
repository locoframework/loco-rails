import { Component, helpers } from "simplicit";

import { escapeHtml } from "helpers/text";
import Message from "models/room/Message";
import { getLoco, renderFlash } from "services/app";

const DISCONNECTED = "Disconnected from the server. Reconnecting…";
const RECONNECTED =
  "Reconnected. Ephemeral messages sent while you were offline weren't delivered.";

export default class RoomChat extends Component {
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

  receivedMessage(message, author, id) {
    if (this.#hasMessage(id)) return;

    const dataId = id == null ? "" : ` data-id="${id}"`;
    const html = `<p class="msg"${dataId}><b>${escapeHtml(author)}</b>: ${escapeHtml(message)}</p>`;
    const list = this.ref("messages");
    const next =
      id == null
        ? null
        : [...list.querySelectorAll("p[data-id]")].find(
            (el) => Number(el.dataset.id) > id,
          );
    if (next) next.insertAdjacentHTML("beforebegin", html);
    else list.insertAdjacentHTML("beforeend", html);
  }

  disconnected() {
    this.wasDisconnected = true;
    renderFlash({ alert: DISCONNECTED });
  }

  reconnected() {
    if (!this.wasDisconnected) return;

    this.wasDisconnected = false;
    renderFlash({ notice: RECONNECTED });
  }

  async rejoined(roomId) {
    if (roomId !== this.roomId) return;

    const ids = [...this.ref("messages").querySelectorAll("p[data-id]")].map(
      (p) => Number(p.dataset.id),
    );
    const { resources } = await Message.all({
      roomId,
      after_id: Math.max(0, ...ids),
    });
    resources.forEach((m) => this.receivedMessage(m.content, m.author, m.id));
  }

  #hasMessage(id) {
    return (
      id != null && this.ref("messages").querySelector(`[data-id="${id}"]`)
    );
  }
}
