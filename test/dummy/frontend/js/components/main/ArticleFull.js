import { Component } from "simplicit";

import { simpleFormat } from "helpers/text";
import DateService from "services/Date";

class ArticleFull extends Component {
  static name = "main-article-full";

  static template = ({
    id,
    title,
    author,
    publishedAt,
    content,
    commentsCount,
  }) => `
    <article id="article_${id}" data-component="main-article-full" data-key="${id}">
      <h1 id="article_title">${title}</h1>
      <p>
        <i>
          <span id="author">${author}</span> wrote this on
          <span id="pub_date">${new DateService(publishedAt).toString("short")}</span> /
          <a id="comments_count" href="#comments"
            >${commentsCount} comment${commentsCount === 1 ? "" : "s"}</a
          >
        </i>
      </p>
      <section id="article_text">${simpleFormat(content)}</section>
    </article>`;
}

export default ArticleFull;
