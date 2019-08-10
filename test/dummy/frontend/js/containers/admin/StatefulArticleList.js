import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "stores/admin";
import Article from "components/admin/Article";
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

  const list = articles.map(article => (
    <Article key={article.id} article={article} />
  ));

  return <>{list}</>;
}

ArticleListWrapper.propTypes = {
  articles: PropTypes.arrayOf(PropTypes.instanceOf(ArticleModel)).isRequired
};

export default ArticleListWrapper;
