import { Component } from "simplicit";

import DateService from "services/Date";

class Article extends Component {
  static name = "admin-article";

  static template = ({
    id,
    title,
    content,
    author,
    publishedAt,
    commentsCount,
  }) => `
    <article id="article_${id}" data-component="admin-article" data-key="${id}">
      <h2>${title}</h2>
      <p>
        <i>
          ${author} wrote this on ${new DateService(publishedAt).toString("short")} /
          <span class="comments_quantity">
            ${commentsCount} comment${commentsCount === 1 ? "" : "s"}
          </span>
        </i>
      </p>
      <p>${content}</p>
      <p><a href="/admin/articles/${id}/edit">Review</a></p>
    </article>`;
}

export default Article;
