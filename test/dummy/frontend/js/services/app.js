let loco = null;

export const setLoco = (val) => (loco = val);
export const getLoco = () => loco;

const component = (name) =>
  document.querySelector(`[data-component="${name}"]`)?.instance ?? null;

export const getChat = () => component("room-chat");

export const renderFlash = (opts = {}) => {
  const [type, msg] = Object.entries(opts)[0] ?? [];
  if (msg == null) return;
  component("flash")?.update({ type, msg });
};
