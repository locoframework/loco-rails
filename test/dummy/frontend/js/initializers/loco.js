import { init, connectWithModel } from "loco-js";
import { connector } from "loco-js-model";
import { createConsumer } from "@rails/actioncable";

import NotificationCenter from "services/NotificationCenter";

import Article from "models/Article";
import Comment from "models/article/Comment";
import Member from "models/room/Member";
import Room from "models/Room";
import User from "models/User";

import renderFlash from "views/shared/Flash";

connectWithModel(connector);

Article.Comment = Comment;
Room.Member = Member;

const loco = init({
  cable: createConsumer(),
  models: {
    Article,
    Room,
    User,
  },
  notificationCenter: NotificationCenter,
  notifications: {
    log: true,
    size: 10,
    disconnectedForTooLong: () => {
      const msg =
        "You have been disconnected from the server for too long. Reload page!";
      renderFlash({ alert: msg, hide: false });
    },
  },
  postInit: () => {
    if (
      document.querySelector("body").getAttribute("data-rails-env") !== "test"
    )
      return;
    loco.getWire().setPollingTime(1000);
  },
});

export default loco;
