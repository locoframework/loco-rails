import React, { useEffect, useState } from "react";
import PropTypes from "prop-types";

import store from "store";
import Article from "components/admin/Article";
import ArticleModel from "models/Article";

function ArticleList(props) {
  const [articles, setArticles] = useState(props.articles);

  useEffect(() => {
    const read = () => setArticles(store.getState().articles);
    read(); // catch dispatches that landed between render and subscribe
    return store.subscribe(read);
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
