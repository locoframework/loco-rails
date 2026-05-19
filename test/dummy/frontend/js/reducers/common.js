import { produce } from "immer";

export default (modelName, { nestedBy } = {}) => {
  const single = modelName.toLowerCase();
  const plural = `${single}s`;
  const M = modelName.toUpperCase();
  const MS = `${M}S`;

  if (nestedBy) {
    return produce((draft = {}, action) => {
      const key = action[nestedBy];
      switch (action.type) {
        case `${MS}.ADD`:
          if (!draft[key]) draft[key] = [];
          draft[key] = draft[key].concat(action[plural]);
          break;
        case `${MS}.PREPEND`:
          if (!draft[key]) draft[key] = [];
          draft[key] = action[plural].concat(draft[key]);
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
        break;
      }
      default:
        return draft;
    }
  });
};
