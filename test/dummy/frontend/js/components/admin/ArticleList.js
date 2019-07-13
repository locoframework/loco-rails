import React from "react";
import PropTypes from "prop-types";

import Article from "./Article";
import ArticleModel from "models/article.coffee";

function ArticleList({ articles }) {
  const list = articles.map(article => (
    <Article key={article.id} article={article} />
  ));

  return <>{list}</>;
}

ArticleList.propTypes = {
  articles: PropTypes.arrayOf(PropTypes.instanceOf(ArticleModel)).isRequired
};

export default ArticleList;
