import { Deps, Loco } from "loco-js";
import ActionCable from "actioncable";

Deps.cable = ActionCable.createConsumer();

const loco = new Loco();
loco.init();
