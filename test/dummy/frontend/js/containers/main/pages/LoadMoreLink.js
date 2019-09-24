import React, { useState } from "react";

import Article from "models/Article";

import { addArticles } from "actions";
import store from "store";

export default function LoadMoreLink() {
  const [page, setPage] = useState(1);
  const [noMorePosts, setNoMorePosts] = useState(false);

  async function handleClick(e) {
    e.preventDefault();
    const currentPage = page + 1;
    setPage(currentPage);
    let resp = null;
    try {
      resp = await Article.get("all", { page: currentPage });
    } catch (e) {
      alert(`Invalid URL: ${e}`);
      return;
    }
    if (resp.resources.length > 0) {
      store.dispatch(addArticles(resp.resources));
    } else {
      setNoMorePosts(true);
    }
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
