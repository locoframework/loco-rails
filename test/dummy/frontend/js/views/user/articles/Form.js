import { subscribe } from "loco-js";
import { UI } from "loco-js-ui";

import { renderFlash } from "services/app";

const displayChanges = (article) => {
  const changes = article.changes();
  for (const sel of document.querySelectorAll("a.apply_changes")) {
    const attrib = article.getAttrName(sel.getAttribute("data-for"));
    sel.classList.toggle("none", changes[attrib] === undefined);
  }
};

const receivedMessage = (type, data) => {
  if (type !== "updating") return;
  if (document.querySelector("h1").getAttribute("data-mark") === data.mark)
    return;
  renderFlash({
    warning: "Uuups someone else started editing this article.",
  });
};

const handleApplyingChanges = (form, article) => {
  for (const sel of document.querySelectorAll("a.apply_changes")) {
    sel.addEventListener("click", (e) => {
      e.preventDefault();
      const attrName = article.getAttrName(e.target.getAttribute("data-for"));
      article[attrName] = article.changes()[attrName].is;
      form.fill(attrName);
      displayChanges(article);
    });
  }
};

export default {
  render: (article) => {
    const unsubscribe = subscribe({ to: article, with: receivedMessage });
    const stopWatching = article.constructor.onChange(() =>
      displayChanges(article),
    );
    const form = new UI.Form({ for: article });
    form.render();
    handleApplyingChanges(form, article);
    return () => {
      unsubscribe();
      stopWatching();
    };
  },
};
