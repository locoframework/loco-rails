import { Deps, Env, I18n, Loco, Utils } from "loco-js";
import { Deps as UIDeps } from "loco-js-ui";
import { createConsumer } from "@rails/actioncable";
import NotificationCenter from "services/NotificationCenter";
import Connectivity from "services/Connectivity";

Deps.cable = createConsumer();
Deps.NotificationCenter = NotificationCenter;

UIDeps.Env = Env;
UIDeps.I18n = I18n;
UIDeps.Utils = Utils;

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
