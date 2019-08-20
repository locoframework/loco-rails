import Flash from "views/shared/Flash";

const Disconnection = {
  disconnectedForTooLong() {
    const msg =
      "You have been disconnected from the server for too long. Reload page!";
    const view = new Flash({ alert: msg, hide: false });
    view.render();
  }
};

export default Disconnection;
