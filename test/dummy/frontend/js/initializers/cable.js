import { Deps } from "loco-js";
import ActionCable from "actioncable";

Deps.cable = ActionCable.createConsumer();
