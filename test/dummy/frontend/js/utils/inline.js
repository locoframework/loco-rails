const parse = (id) => JSON.parse(document.getElementById(id).textContent);

export const inlineList = (id, Model) => parse(id).map((d) => new Model(d));

export const inlineOne = (id, Model) => new Model(parse(id));
