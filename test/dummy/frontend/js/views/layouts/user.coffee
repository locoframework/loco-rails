import { Views } from "loco-js";

class User extends Views.Base
  constructor: (opts = {}) -> super opts

  getCurrentUserId: ->
    parseInt(document.getElementById('sign_out_user').getAttribute(''))

export default User;
