import { Component } from "simplicit";

export default class Flash extends Component {
  static name = "flash";

  static template = ({ type, msg }) => `
    <div class="flash ${type}" data-component="flash">
      <p>${msg}</p>
    </div>`;
}
