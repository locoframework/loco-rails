import { init, connectWithModel } from "loco-js";
import { Config, connector, I18n } from "loco-js-model";
import { connect } from "loco-js-ui";
import { createConsumer } from "@rails/actioncable";

import { setLoco } from "services/loco";
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
  models: [Article, Room, User],
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

setLoco(loco);

// loco-js-ui reads the Wire off the instance the moment it connects, so it has
// to run here rather than in an initializer of its own whose ordering against
// this one nothing enforces.
connect({
  getLocale: () => Config.locale,
  loco,
  I18n,
});
