import { Component } from "simplicit";

import ArticleModel from "models/Article";

class LoadMore extends Component {
  static name = "load-more";

  static template = ({ noMorePosts }) => `
    <p id="load_more_wrapper" data-component="load-more">
      ${
        noMorePosts
          ? "<span>No more posts.</span>"
          : '<a href="#" id="load_more" data-ref="link">Load more…</a>'
      }
    </p>`;

  page = 1;

  connect() {
    this.on("link", "click", (e) => this.loadMore(e));
    this.update({ noMorePosts: false });
  }

  async loadMore(e) {
    e.preventDefault();
    this.page += 1;
    const resp = await ArticleModel.get("all", { page: this.page });
    if (resp.resources.length === 0) return this.update({ noMorePosts: true });
    resp.resources.forEach((article) => ArticleModel.add(article));
  }
}

export default LoadMore;
