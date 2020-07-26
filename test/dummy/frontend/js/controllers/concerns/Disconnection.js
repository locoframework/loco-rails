import renderFlash from "views/shared/Flash";

const Disconnection = {
  disconnectedForTooLong() {
    const msg =
      "You have been disconnected from the server for too long. Reload page!";
    renderFlash({ alert: msg, hide: false });
  }
};

export default Disconnection;
