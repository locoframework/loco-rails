import { subscribe } from "loco-js";
import { simpleFormat } from "helpers/text";
import DateService from "services/Date";
import { UI } from "loco-js-ui";

import renderFlash from "views/shared/Flash";

const createArticleReceivedMessage = article => {
  return async function(type) {
    switch (type) {
      case "updating": {
        const txt =
          "Author is currently editing article. Be aware of possible changes.";
        renderFlash({ warning: txt });
        break;
      }
      case "updated": {
        const reloadedArticle = await article.reload();
        renderArticle(reloadedArticle, true);
      }
    }
  };
};

const renderArticle = (article, update = false) => {
  if (update === false) {
    subscribe({ to: article, with: createArticleReceivedMessage(article) });
  }
  document.getElementById("title").textContent = article.title;
  document.getElementById("author").textContent = article.author;
  const dateService = new DateService(article.publishedAt);
  document.getElementById("pub_date").textContent = dateService.toString(
    "short"
  );
  const textEl = document.getElementById("text");
  textEl.innerHTML = "";
  const text = simpleFormat(article.content);
  textEl.insertAdjacentHTML("beforeend", text);
};

const renderForm = comment => {
  const form = new UI.Form({
    for: comment,
    initObj: true,
    id: "new_comment"
  });
  form.render();
};

export default {
  renderArticle,
  renderForm
};
