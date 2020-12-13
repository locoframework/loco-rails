import { getWire, connector as locoConnector, init } from "loco-js";
import { connect as connectUI } from "loco-js-ui";
import { createConsumer } from "@rails/actioncable";

import NotificationCenter from "services/NotificationCenter";

import Article from "models/Article";
import Comment from "models/article/Comment";
import Member from "models/room/Member";
import Room from "models/Room";
import User from "models/User";

import Admin from "controllers/Admin";
import Main from "controllers/Main";
import UserController from "controllers/User";

Article.Comment = Comment;
Room.Member = Member;

init({
  cable: createConsumer(),
  controllers: {
    Admin,
    Main,
    User: UserController
  },
  models: {
    Article,
    Room,
    User
  },
  notificationCenter: NotificationCenter,
  notifications: {
    log: true,
    size: 10
  },
  postInit: () => {
    if (
      document.querySelector("body").getAttribute("data-rails-env") !== "test"
    )
      return;
    getWire().setPollingTime(1000);
  }
});

connectUI(locoConnector);
