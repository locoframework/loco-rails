const updateEditLink = user => {
  const editLink = document.getElementById("edit_link");
  const href = editLink.getAttribute("href");
  editLink.setAttribute("href", href.replace("/0/", `/${user.id}/`));
};

export default user => {
  document.getElementById("user_email").textContent = user.email;
  document.getElementById("user_username").textContent = user.username;
  document.getElementById("user_confirmed").textContent = user.confirmed
    ? "Yes"
    : "No";
  updateEditLink(user);
};
