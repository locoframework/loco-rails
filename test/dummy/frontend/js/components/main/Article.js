import React from "react";
import PropTypes from "prop-types";
import { Services } from "loco-js";

import ArticleModel from "models/article.coffee";

function Article({ article }) {
  const date = new Services.Date(article.publishedAt).toString("short");

  return (
    <article id={`article_${article.id}`}>
      <h2>{article.title}</h2>
      <p>
        <i>
          {article.author} wrote this on {date} /{" "}
          <a
            href={`/articles/${article.id}#comments`}
            className="comments_quantity"
          >
            {article.commentsCount} comment
            {article.commentsCount === 1 ? "" : "s"}
          </a>
        </i>
      </p>
      <p>{article.content}</p>
      <p>
        <a href={`/articles/${article.id}`}>Continued…</a>
      </p>
    </article>
  );
}

Article.propTypes = {
  article: PropTypes.instanceOf(ArticleModel).isRequired
};

export default Article;
