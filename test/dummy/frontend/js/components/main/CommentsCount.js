import { Component } from "simplicit";

class CommentsCount extends Component {
  static name = "comments-count";

  static template = ({ records }) => `
    <a id="comments_count" href="#comments" data-component="comments-count"
      >${records.length} comment${records.length === 1 ? "" : "s"}</a
    >`;
}

export default CommentsCount;
