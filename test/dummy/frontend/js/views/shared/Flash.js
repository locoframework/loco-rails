const resetNode = (node) => {
  node.classList.remove("notice");
  node.classList.remove("alert");
  node.classList.remove("warning");
};

const setMsg = (opts, msg, node) => {
  if (opts[msg] == null) return;
  node.classList.add(msg);
  document.querySelector(".flash p").textContent = opts[msg];
};

const hideAfterTime = (time = 4000) => {
  setTimeout(() => {
    document.querySelector(".flash").classList.add("none"); // slideUp initially
  }, time);
};

export default (opts = {}) => {
  const { hide } = opts;
  const node = document.querySelector(".flash");
  resetNode(node);
  setMsg(opts, "notice", node);
  setMsg(opts, "alert", node);
  setMsg(opts, "warning", node);
  node.classList.remove("none"); // slideDown initially
  if (hide) hideAfterTime();
};
