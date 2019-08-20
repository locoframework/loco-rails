import { Env } from "loco-js";

import UserController from "controllers/User";
import RoomsController from "controllers/user/Rooms";

class NotificationCenter {
  receivedSignal(data) {
    switch (data.signal) {
      case "ping":
        this._pingSignal();
        break;
      case "message":
        this._messageSignal(data);
    }
  }

  _pingSignal() {
    if (Env.namespaceController.constructor !== UserController) return;
    alert("Ping!");
  }

  _messageSignal(data) {
    const view = this._getRoomView();
    if (!view) return;
    view.receivedMessage(data.message, data.author);
  }

  _getRoomView() {
    if (Env.namespaceController.constructor !== UserController) return false;
    if (Env.controller.constructor !== RoomsController) return false;
    if (Env.action !== "show") return false;
    return Env.controller.getView("show");
  }
}

export default NotificationCenter;
