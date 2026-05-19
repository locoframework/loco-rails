import { produce } from "immer";

export default (modelName) => {
  const single = modelName.toLowerCase();
  const plural = `${single}s`;
  const M = modelName.toUpperCase();
  const MS = `${M}S`;

  return produce((draft = [], action) => {
    switch (action.type) {
      case `${MS}.ADD`:
        return draft.concat(
          action[plural].filter((n) => !draft.some((e) => e.id === n.id)),
        );
      case `${MS}.PREPEND`:
        return action[plural].concat(draft);
      case `${MS}.SET`:
        return action[plural];
      case `${M}.REMOVE`:
        return draft.filter((o) => o.id !== action.id);
      case `${M}.UPDATE`: {
        const idx = draft.findIndex((o) => o.id === action[single].id);
        if (idx !== -1) draft[idx] = { ...draft[idx], ...action[single] };
        return draft;
      }
      default:
        return draft;
    }
  });
};
