import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "stores/main";
import ArticleList from "components/main/ArticleList";
import ArticleModel from "models/article.coffee";

function ArticleListWrapper(props) {
  const [articles, setArticles] = useState(props.articles);

  useEffect(() => {
    const unsubscribe = store.subscribe(() =>
      setArticles(store.getState().articles)
    );

    return () => {
      unsubscribe();
    };
  });

  return <ArticleList articles={articles} />;
}

ArticleListWrapper.propTypes = {
  articles: PropTypes.arrayOf(PropTypes.instanceOf(ArticleModel)).isRequired
};

export default ArticleListWrapper;
