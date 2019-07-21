import React from "react";
import PropTypes from "prop-types";

import ArticleModel from "models/article.coffee";

function Article({ article }) {
  return (
    <tr id={`article_${article.id}`}>
      <td>{article.title}</td>
      <td>{article.content}</td>
      <td className="comments_quantity">{article.commentsCount}</td>
      <td className="published">{article.publishedAt ? "yes" : "no"}</td>
      <td>
        <a href={`/user/articles/${article.id}`}>Show</a> |
        <a href={`/user/articles/${article.id}/edit`}>Edit</a> |
        <a href={`/user/articles/${article.id}`} className="delete_article">
          Delete
        </a>
      </td>
    </tr>
  );
}

Article.propTypes = {
  article: PropTypes.instanceOf(ArticleModel).isRequired
};

export default Article;
