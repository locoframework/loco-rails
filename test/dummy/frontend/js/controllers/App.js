import { Controllers } from "loco-js";
import renderFlash from "views/shared/Flash";

export default class extends Controllers.Base {
  disconnectedForTooLong() {
    const msg =
      "You have been disconnected from the server for too long. Reload page!";
    renderFlash({ alert: msg, hide: false });
  }
}
