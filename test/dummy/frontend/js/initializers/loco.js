import { Env, Loco, connector } from "loco-js";
import { connect } from "loco-js-ui";
import { createConsumer } from "@rails/actioncable";
import NotificationCenter from "services/NotificationCenter";
import Connectivity from "services/Connectivity";

connect(connector);

const connectivity = new Connectivity();

const loco = new Loco({
  cable: createConsumer(),
  notificationCenter: NotificationCenter,
  notifications: {
    enable: true,
    log: true,
    size: 10
  },
  postInit: () => {
    connectivity.call();

    if (
      document.querySelector("body").getAttribute("data-rails-env") !== "test"
    )
      return;
    Env.loco.getWire().setPollingTime(1000);
  }
});

loco.init();
