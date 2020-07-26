export const createFinder = resourceType => {
  return function(state, id, opts = {}) {
    let resources = state[resourceType];
    if (opts.parentId) resources = resources[opts.parentId];
    const resource = resources.find(a => a.id === id);
    if (!resource) return [null, null];
    const index = resources.indexOf(resource);
    return [resource, index];
  };
};
