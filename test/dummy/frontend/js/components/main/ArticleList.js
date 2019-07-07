import React from "react";
import PropTypes from "prop-types";

import Article from "./Article";
import ArticleModel from "models/article.coffee";

function ArticleList(props) {
  const articles = props.articles.map(article => (
    <Article key={`article_${article.id}`} article={article} />
  ));

  return <React.Fragment>{articles}</React.Fragment>;
}

ArticleList.propTypes = {
  articles: PropTypes.arrayOf(PropTypes.instanceOf(ArticleModel)).isRequired
};

export default ArticleList;
