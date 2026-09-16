import { Component } from "simplicit";

class ArticleReview extends Component {
  static name = "admin-article-review";

  static template = ({ id, author, title, content }) => `
    <div data-component="admin-article-review" data-key="${id}">
      <p>
        <strong>Author:</strong>
        <span id="article_author">${author}</span>
      </p>

      <p>
        <strong>Title:</strong>
        <span id="article_title">${title}</span>
      </p>

      <p>
        <strong>Text:</strong>
        <span id="article_text">${content}</span>
      </p>
    </div>`;
}

export default ArticleReview;
