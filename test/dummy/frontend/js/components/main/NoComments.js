import { Component } from "simplicit";

class NoComments extends Component {
  static name = "no-comments";

  static template = ({ records }) =>
    `<p id="no_comments" data-component="no-comments"${records.length ? " hidden" : ""}>No comments.</p>`;
}

export default NoComments;
