import { Controllers } from "loco-js";

import Form from "views/admin/sessions/form.coffee";

class Sessions extends Controllers.Base
  new: ->
    (new Form).render();

export default Sessions;