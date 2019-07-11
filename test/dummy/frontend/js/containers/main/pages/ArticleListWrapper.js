import React, { useEffect, useReducer } from "react";
import PropTypes from "prop-types";

import reducer from "reducers/main";
import ArticleList from "components/main/ArticleList";
import ArticleModel from "models/article.coffee";
import Connectivity from "services/Connectivity";

const connectivity = new Connectivity();

function ArticleListWrapper({ articles }) {
  const [state, dispatch] = useReducer(reducer, { articles: articles });

  useEffect(() => {
    const callbacks = {
      onArticlePublished: article =>
        dispatch({ type: "ADD", payload: { articles: [article] } })
    };

    connectivity.call({ callbacks: callbacks });
  });

  return <ArticleList articles={state.articles} />;
}

ArticleListWrapper.propTypes = {
  articles: PropTypes.arrayOf(PropTypes.instanceOf(ArticleModel)).isRequired
};

export default ArticleListWrapper;
