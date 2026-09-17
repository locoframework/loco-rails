import { Component } from "simplicit";

class Flash extends Component {
  static name = "flash";

  static template = ({ type, msg }) => `
    <div class="flash ${type}" data-component="flash">
      <p>${msg}</p>
    </div>`;
}

export default Flash;
