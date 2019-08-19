import Flash from "views/shared/Flash";

class Disconnection {
  disconnectedForTooLong() {
    const msg =
      "You have been disconnected from the server for too long. Reload page!";
    const view = new Flash({ alert: msg, hide: false });
    view.render();
  }
}

export default Disconnection;
