import { Env, connector as locoConnector, init } from "loco-js";
import { connect as connectUI } from "loco-js-ui";
import { createConsumer } from "@rails/actioncable";
import NotificationCenter from "services/NotificationCenter";
import Connectivity from "services/Connectivity";

init({
  cable: createConsumer(),
  notificationCenter: NotificationCenter,
  notifications: {
    enable: true,
    log: true,
    size: 10
  },
  postInit: () => {
    new Connectivity().call();

    if (
      document.querySelector("body").getAttribute("data-rails-env") !== "test"
    )
      return;
    Env.loco.getWire().setPollingTime(1000);
  }
});

connectUI(locoConnector);
