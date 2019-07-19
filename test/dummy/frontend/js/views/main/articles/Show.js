import { Helpers, Services, UI, Views } from "loco-js";

import Flash from "views/shared/flash.coffee";

class Show extends Views.Base {
  constructor(opts = {}) {
    super(opts);
    this.article = null;
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

  renderArticle(article = null) {
    if (!this.article) {
      this.article = article;
      this.connectWith(this.article, { receiver: "_articleReceivedSignal" });
    }
    document.getElementById("title").textContent = this.article.title;
    document.getElementById("author").textContent = this.article.author;
    const dateService = new Services.Date(this.article.publishedAt);
    document.getElementById("pub_date").textContent = dateService.toString(
      "short"
    );
    const textEl = document.getElementById("text");
    textEl.innerHTML = "";
    const text = new Helpers.Text().simpleFormat(this.article.content);
    textEl.insertAdjacentHTML("beforeend", text);
  }

  _articleReceivedSignal(signal) {
    switch (signal) {
      case "updating": {
        const txt =
          "Author is currently editing article. Be aware of possible changes.";
        const flash = new Flash({ warning: txt });
        flash.render();
        break;
      }
      case "updated":
        this.article.reload().then(() => {
          this.article.applyChanges();
          this.renderArticle();
        });
    }
  }
}

export default Show;
