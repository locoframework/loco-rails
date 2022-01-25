import React from "react";
import PropTypes from "prop-types";
import DateService from "services/Date";

import ArticleModel from "models/Article";

function Article({ article }) {
  const date = new DateService(article.publishedAt).toString("short");

  return (
    <article id={`article_${article.id}`}>
      <h2>{article.title}</h2>
      <p>
        <i>
          {article.author} wrote this on {date} /{" "}
          <span className="comments_quantity">
            {article.commentsCount} comment
            {article.commentsCount === 1 ? "" : "s"}
          </span>
        </i>
      </p>
      <p>{article.content}</p>
      <p>
        <a href={`/admin/articles/${article.id}/edit`}>Review</a>
      </p>
    </article>
  );
}

Article.propTypes = {
  article: PropTypes.instanceOf(ArticleModel).isRequired,
};

export default Article;
