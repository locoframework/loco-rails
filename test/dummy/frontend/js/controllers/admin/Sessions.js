import { Controllers } from "loco-js";

import renderForm from "views/admin/sessions/Form";

class Sessions extends Controllers.Base {
  new() {
    renderForm();
  }
}

export default Sessions;
