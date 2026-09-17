import { Component } from "simplicit";

class ArticleShow extends Component {
  static name = "user-article-show";

  static #publishLink = (publishedAt, publishState) => {
    if (publishState === "published") return "<span>Published!</span>";
    if (publishedAt != null) return "";
    const label = publishState === "publishing" ? "Publishing..." : "Publish";
    return `<a href="#" id="publish_article" data-ref="publish">${label}</a>`;
  };

  static template = ({ id, title, content, publishedAt, publishState }) => `
    <div data-component="user-article-show" data-key="${id}">
      <p>
        <strong>Title:</strong>
        <span id="article_title">${title}</span>
      </p>

      <p>
        <strong>Text:</strong>
        <span id="article_text">${content}</span>
      </p>

      <p>${ArticleShow.#publishLink(publishedAt, publishState)}</p>
    </div>`;

  connect() {
    this.on("publish", "click", (e) => this.#publish(e));
  }

  async #publish(e) {
    e.preventDefault();
    this.update({ publishState: "publishing" });
    await this.model.put("publish");
    this.update({ publishState: "published" });
  }
}

export default ArticleShow;
