export const createFinder =
  (resourceType) =>
  (state, id, opts = {}) => {
    const collection = opts.parentId
      ? state[resourceType]?.[opts.parentId]
      : state[resourceType];
    return collection?.find((r) => r.id === id) ?? null;
  };
