import getEnv from "initializers/simplicit";

import AdminController from "controllers/Admin";
import MainController from "controllers/Main";
import RoomsController from "controllers/user/Rooms";
import UserController from "controllers/User";

export const userNamespace = () =>
  getEnv().namespaceController.constructor === UserController;

export const adminNamespace = () =>
  getEnv().namespaceController.constructor === AdminController;

export const mainNamespace = () =>
  getEnv().namespaceController.constructor === MainController;

export const inChatRoom = () =>
  userNamespace() &&
  getEnv().controller !== null &&
  getEnv().controller.constructor === RoomsController &&
  getEnv().action === "show";
