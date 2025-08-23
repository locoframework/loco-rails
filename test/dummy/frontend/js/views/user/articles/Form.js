import React from "react";
import { createRoot } from "react-dom/client";
import { subscribe } from "loco-js";
import { UI } from "loco-js-ui";

import { addArticles, setComments } from "actions";
import store from "store";

import Comment from "models/article/Comment";

import renderFlash from "views/shared/Flash";

import CommentList from "containers/user/CommentList";

const displayChanges = (article) => {
  for (const [attrib] of Object.entries(article.changes())) {
    const sel = document.querySelector(
      `a.apply_changes[data-for=${article.getAttrRemoteName(attrib)}]`,
    );
    if (!sel) continue;
    sel.classList.remove("none");
  }
};

const createReceivedMessage = (article) => {
  return async function (type, data) {
    switch (type) {
      case "updating":
        if (
          document.querySelector("h1").getAttribute("data-mark") !== data.mark
        ) {
          renderFlash({
            warning: "Uuups someone else started editing this article.",
          });
        }
        break;
      case "updated":
        await article.reload();
        displayChanges(article);
        break;
      case "destroyed":
        window.location.href = "/user/articles?message=deleted";
    }
  };
};

const handleApplyingChanges = (form) => {
  for (const sel of Array.from(document.querySelectorAll("a.apply_changes"))) {
    sel.addEventListener("click", (e) => {
      e.preventDefault();
      const article = form.getObj();
      const attrName = article.getAttrName(e.target.getAttribute("data-for"));
      article[attrName] = article.changes()[attrName].is;
      form.fill(attrName);
      e.target.classList.add("none");
    });
  }
};

export default {
  render: (article) => {
    store.dispatch(addArticles([article]));
    const unsubscribe = subscribe({
      to: article,
      with: createReceivedMessage(article),
    });
    const form = new UI.Form({ for: article });
    form.render();
    handleApplyingChanges(form);
    return unsubscribe;
  },

  renderComments: async (articleId) => {
    const resp = await Comment.all({ articleId: articleId });
    store.dispatch(setComments(resp.resources, articleId));
    createRoot(document.getElementById("comments")).render(
      <CommentList
        articleId={articleId}
        comments={resp.resources}
        isAdmin={true}
      />,
    );
  },
};
