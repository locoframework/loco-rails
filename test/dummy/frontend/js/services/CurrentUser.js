export default () => {
  const el = document.getElementById("current-user-data");
  const user = JSON.parse(el.textContent);
  return user;
};
