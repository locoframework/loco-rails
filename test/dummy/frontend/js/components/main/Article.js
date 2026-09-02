import { Component } from "simplicit";

import DateService from "services/Date";

const publishedOn = (date) =>
  date ? new DateService(date).toString("short") : "";

class Article extends Component {
  static name = "main-article";

  static template = ({
    id,
    title,
    content,
    author,
    publishedAt,
    commentsCount,
  }) => `
    <article id="article_${id}" data-component="main-article" data-key="${id}">
      <h2>${title}</h2>
      <p>
        <i>
          ${author} wrote this on ${publishedOn(publishedAt)} /
          <a href="/articles/${id}#comments" class="comments_quantity">
            ${commentsCount} comment${commentsCount === 1 ? "" : "s"}
          </a>
        </i>
      </p>
      <p>${content}</p>
      <p><a href="/articles/${id}">Continued…</a></p>
    </article>`;
}

export default Article;
