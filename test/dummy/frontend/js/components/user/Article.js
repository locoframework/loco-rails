import React from "react";
import PropTypes from "prop-types";

import ArticleModel from "models/article.coffee";

import store from "stores/user";

function Article({ article, onArticleDestroyed }) {
  const handleDeletingArticle = e => {
    e.preventDefault();
    if (!confirm("Are you sure?")) return;
    article.delete(null).then(data => {
      if (data.success) {
        store.dispatch({
          type: "REMOVE_ARTICLE",
          payload: { id: data.id }
        });
      }
      onArticleDestroyed(data);
    });
  };

  return (
    <tr id={`article_${article.id}`}>
      <td>{article.title}</td>
      <td>{article.content}</td>
      <td className="comments_quantity">{article.commentsCount}</td>
      <td className="published">{article.publishedAt ? "yes" : "no"}</td>
      <td>
        <a href={`/user/articles/${article.id}`}>Show</a> |
        <a href={`/user/articles/${article.id}/edit`}>Edit</a> |
        <a
          href={`/user/articles/${article.id}`}
          className="delete_article"
          onClick={handleDeletingArticle}
        >
          Delete
        </a>
      </td>
    </tr>
  );
}

Article.propTypes = {
  article: PropTypes.instanceOf(ArticleModel).isRequired,
  onArticleDestroyed: PropTypes.func.isRequired
};

export default Article;
