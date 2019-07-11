import { Deps, Env, Loco } from "loco-js";
import ActionCable from "actioncable";
import NotificationCenter from "services/notification_center.coffee";
import Connectivity from "services/Connectivity";

Deps.cable = ActionCable.createConsumer();
Deps.NotificationCenter = NotificationCenter;

const connectivity = new Connectivity();

const loco = new Loco({
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
