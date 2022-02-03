import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "store";
import Article from "components/main/Article";
import ArticleModel from "models/Article";

function ArticleList(props) {
  const [articles, setArticles] = useState(props.articles);

  useEffect(() => {
    const unsubscribe = store.subscribe(() =>
      setArticles(store.getState().articles)
    );

    return () => {
      unsubscribe();
    };
  }, []);

  const list = articles.map((article) => (
    <Article key={article.id} article={article} />
  ));

  return <>{list}</>;
}

ArticleList.propTypes = {
  articles: PropTypes.arrayOf(PropTypes.instanceOf(ArticleModel)).isRequired,
};

export default ArticleList;
