import { subscribe, Views } from "loco-js";
import { simpleFormat } from "helpers/text";
import DateService from "services/Date";
import { UI } from "loco-js-ui";

import Flash from "views/shared/Flash";

let article = null;

const articleReceivedSignal = async signal => {
  switch (signal) {
    case "updating": {
      const txt =
        "Author is currently editing article. Be aware of possible changes.";
      const flash = new Flash({ warning: txt });
      flash.render();
      break;
    }
    case "updated":
      await article.reload();
      article.applyChanges();
      renderArticle();
  }
};

const renderArticle = (anArticle = null) => {
  if (!article) {
    article = anArticle;
    subscribe({ to: article, with: articleReceivedSignal });
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

class Show extends Views.Base {
  constructor(opts = {}) {
    super(opts);
    article = null;
    this.newComment = opts.comment;
  }

  render() {
    const form = new UI.Form({
      for: this.newComment,
      initObj: true,
      id: "new_comment"
    });
    form.render();
  }
}

export default Show;
export { renderArticle };
