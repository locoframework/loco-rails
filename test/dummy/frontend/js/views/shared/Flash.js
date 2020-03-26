class Flash {
  constructor(opts = {}) {
    this.notice = opts.notice;
    this.alert = opts.alert;
    this.warning = opts.warning;
    this.hide = opts.hide;
  }

  setNotice(text) {
    this.notice = text;
  }
  setAlert(text) {
    this.alert = text;
  }
  setWarning(text) {
    this.warning = text;
  }

  render() {
    const node = document.querySelector(".flash");
    node.classList.remove("notice");
    node.classList.remove("alert");
    node.classList.remove("warning");
    if (this.notice != null) {
      node.classList.add("notice");
      document.querySelector(".flash p").textContent = this.notice;
    } else if (this.alert != null) {
      node.classList.add("alert");
      document.querySelector(".flash p").textContent = this.alert;
    } else if (this.warning != null) {
      node.classList.add("warning");
      document.querySelector(".flash p").textContent = this.warning;
    }
    node.classList.remove("none"); // slideDown initially
    if (this.hide) this.hideAfterTime();
  }

  hideAfterTime(time = 4000) {
    setTimeout(() => {
      document.querySelector(".flash").classList.add("none"); // slideUp initially
    }, time);
  }
}

export default Flash;
