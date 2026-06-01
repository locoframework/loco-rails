import { produce } from "immer";

export default (modelName, { nestedBy } = {}) => {
  const single = modelName.toLowerCase();
  const plural = `${single}s`;
  const M = modelName.toUpperCase();
  const MS = `${M}S`;

  const append = (current, items) =>
    current.concat(items.filter((n) => !current.some((e) => e.id === n.id)));

  if (nestedBy) {
    return produce((draft = {}, action) => {
      const key = action[nestedBy];
      switch (action.type) {
        case `${MS}.ADD`:
          draft[key] = append(draft[key] || [], action[plural]);
          break;
        case `${MS}.SET`:
          draft[key] = action[plural];
          break;
        case `${M}.REMOVE`:
          if (!draft[key]) return draft;
          draft[key] = draft[key].filter((o) => o.id !== action.id);
          break;
        case `${M}.UPDATE`: {
          if (!draft[key]) return draft;
          const idx = draft[key].findIndex((o) => o.id === action[single].id);
          if (idx !== -1) {
            draft[key][idx] = { ...draft[key][idx], ...action[single] };
          }
          break;
        }
        default:
          return draft;
      }
    });
  }

  return produce((draft = [], action) => {
    switch (action.type) {
      case `${MS}.ADD`:
        return append(draft, action[plural]);
      case `${MS}.SET`:
        return action[plural];
      case `${M}.REMOVE`:
        return draft.filter((o) => o.id !== action.id);
      case `${M}.UPDATE`: {
        const idx = draft.findIndex((o) => o.id === action[single].id);
        if (idx !== -1) draft[idx] = { ...draft[idx], ...action[single] };
        break;
      }
      default:
        return draft;
    }
  });
};
