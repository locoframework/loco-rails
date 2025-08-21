import { init, connectWithModel } from "loco-js";
import { connector } from "loco-js-model";
import { createConsumer } from "@rails/actioncable";

import NotificationCenter from "services/NotificationCenter";

import Article from "models/Article";
import Comment from "models/article/Comment";
import Member from "models/room/Member";
import Room from "models/Room";
import User from "models/User";

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
