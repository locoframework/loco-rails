export const toURIParams = obj => {
  let str = "";
  Object.keys(obj).forEach(key => {
    if (str !== "") str = `${str}&`;
    str = `${str}${key}=${encodeURIComponent(obj[key])}`;
  });
  return str;
};

export default toURIParams;
