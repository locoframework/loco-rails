const resetNode = node => {
  node.classList.remove("notice");
  node.classList.remove("alert");
  node.classList.remove("warning");
};

const setMsg = (flash, msg, node) => {
  if (flash[msg] == null) return;
  node.classList.add(msg);
  document.querySelector(".flash p").textContent = flash[msg];
};

const hideAfterTime = (time = 4000) => {
  setTimeout(() => {
    document.querySelector(".flash").classList.add("none"); // slideUp initially
  }, time);
};

class Flash {
  constructor(opts = {}) {
    this.notice = opts.notice;
    this.alert = opts.alert;
    this.warning = opts.warning;
    this.hide = opts.hide;
  }

  render() {
    const node = document.querySelector(".flash");
    resetNode(node);
    setMsg(this, "notice", node);
    setMsg(this, "alert", node);
    setMsg(this, "warning", node);
    node.classList.remove("none"); // slideDown initially
    if (this.hide) hideAfterTime();
  }
}

export default Flash;
