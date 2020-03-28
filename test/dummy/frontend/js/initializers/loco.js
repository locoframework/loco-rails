import { Env, connector as locoConnector, init } from "loco-js";
import { connect as connectUI } from "loco-js-ui";
import { createConsumer } from "@rails/actioncable";
import NotificationCenter from "services/NotificationCenter";

init({
  cable: createConsumer(),
  notificationCenter: NotificationCenter,
  notifications: {
    enable: true,
    log: true,
    size: 10
  },
  postInit: () => {
    if (
      document.querySelector("body").getAttribute("data-rails-env") !== "test"
    )
      return;
    Env.loco.wire.setPollingTime(1000);
  }
});

connectUI(locoConnector);
