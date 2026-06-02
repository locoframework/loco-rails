import { produce } from "immer";

const append = (current, items) =>
  current.concat(items.filter((n) => !current.some((e) => e.id === n.id)));

const reduceList = (list, action, { single, plural, MS }) => {
  switch (action.type) {
    case `${MS}.ADD`:
      return append(list, action[plural]);
    case `${MS}.SET`:
      return action[plural];
    case `${MS}.REMOVE`:
      return list.filter((o) => o.id !== action.id);
    case `${MS}.UPDATE`: {
      const idx = list.findIndex((o) => o.id === action[single].id);
      if (idx !== -1) list[idx] = { ...list[idx], ...action[single] };
      return list;
    }
    default:
      return list;
  }
};

export default (modelName, { nestedBy } = {}) => {
  const single = modelName.toLowerCase();
  const plural = `${single}s`;
  const MS = `${single.toUpperCase()}S`;
  const names = { single, plural, MS };

  if (nestedBy) {
    return produce((draft = {}, action) => {
      const key = action[nestedBy];
      if (
        draft[key] === undefined &&
        action.type !== `${MS}.ADD` &&
        action.type !== `${MS}.SET`
      ) {
        return draft;
      }
      draft[key] = reduceList(draft[key] || [], action, names);
    });
  }

  return produce((draft = [], action) => reduceList(draft, action, names));
};
