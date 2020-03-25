import { Views } from "loco-js";

class Show extends Views.Base {
  constructor(opts = {}) {
    super();
    this.user = opts.user;
  }

  render() {
    document.getElementById("user_email").textContent = this.user.email;
    document.getElementById("user_username").textContent = this.user.username;
    document.getElementById("user_confirmed").textContent = this.user.confirmed
      ? "Yes"
      : "No";
    this._updateEditLink();
  }

  _updateEditLink() {
    const editLink = document.getElementById("edit_link");
    const href = editLink.getAttribute("href");
    editLink.setAttribute("href", href.replace("/0/", "/#{@user.id}/"));
  }
}

export default Show;
