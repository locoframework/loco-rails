// Holds the Loco instance for whoever needs it, so nothing has to import
// `initializers/loco` — that module runs init() at eval and pulls the whole
// app graph in with it, which is how two import cycles formed.
//
// Keep this file free of imports. A cycle needs every module in it to import
// the next one, so a module that imports nothing cannot be on one.
let instance = null;

export const setLoco = (loco) => (instance = loco);

export const getLoco = () => instance;
