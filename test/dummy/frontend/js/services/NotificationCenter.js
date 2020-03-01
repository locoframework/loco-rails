import { Env } from "loco-js";

import UserController from "controllers/User";
import RoomsController from "controllers/user/Rooms";

const pingSignal = () => {
  if (Env.namespaceController.constructor !== UserController) return;
  alert("Ping!");
};

const getRoomView = () => {
  if (Env.namespaceController.constructor !== UserController) return false;
  if (Env.controller.constructor !== RoomsController) return false;
  if (Env.action !== "show") return false;
  return Env.controller.getView("show");
};

const messageSignal = data => {
  const view = getRoomView();
  if (!view) return;
  view.receivedMessage(data.message, data.author);
};

export default data => {
  switch (data.signal) {
    case "ping":
      pingSignal();
      break;
    case "message":
      messageSignal(data);
  }
};
