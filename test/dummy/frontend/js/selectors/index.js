export const createFinder = resourceType => {
  return function find(state, id, opts = {}) {
    let resources = state[resourceType];
    if (opts.subResourceId) resources = resources[opts.subResourceId];
    const resource = resources.find(a => a.id === id);
    if (!resource) return [null, null];
    const index = resources.indexOf(resource);
    return [resource, index];
  };
};
