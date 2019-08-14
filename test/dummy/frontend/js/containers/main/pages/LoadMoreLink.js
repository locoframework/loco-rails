import React, { useState } from "react";

import Article from "models/Article";
import store from "stores/main";

export default function LoadMoreLink() {
  const [page, setPage] = useState(1);
  const [noMorePosts, setNoMorePosts] = useState(false);

  function handleClick(e) {
    e.preventDefault();
    const currentPage = page + 1;
    setPage(currentPage);
    Article.get("all", { page: currentPage })
      .then(resp => {
        if (resp.resources.length > 0) {
          store.dispatch({
            type: "ADD_ARTICLES",
            payload: { articles: resp.resources }
          });
        } else {
          setNoMorePosts(true);
        }
      })
      .catch(err => alert(`Invalid URL: ${err}`));
  }

  function output() {
    if (noMorePosts) return <span>No more posts.</span>;
    else
      return (
        <a href="#" id="load_more" onClick={handleClick}>
          Load more…
        </a>
      );
  }

  return output();
}
