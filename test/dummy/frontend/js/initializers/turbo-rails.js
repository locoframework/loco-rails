import "@hotwired/turbo-rails";

document.addEventListener("turbo:before-render", (event) => {
  const { namespace, controller, action } = event.detail.newBody.dataset;

  document.body.dataset.namespace = namespace;
  document.body.dataset.controller = controller;
  document.body.dataset.action = action;
});
