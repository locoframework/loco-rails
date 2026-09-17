import { Component } from "simplicit";

import { renderFlash } from "services/app";

class Article extends Component {
  static name = "user-article";

  static template = ({ id, title, content, commentsCount, publishedAt }) => `
    <tr id="article_${id}" data-component="user-article" data-key="${id}">
      <td class="title">${title}</td>
      <td>${content}</td>
      <td class="comments_quantity">${commentsCount}</td>
      <td class="published">${publishedAt ? "yes" : "no"}</td>
      <td>
        <a href="/user/articles/${id}">Show</a> |
        <a href="/user/articles/${id}/edit">Edit</a> |
        <a href="/user/articles/${id}" class="delete_article" data-ref="delete">Delete</a>
      </td>
    </tr>`;

  connect() {
    this.on("delete", "click", async (e) => {
      e.preventDefault();
      if (!confirm("Are you sure?")) return;
      const data = await this.model.delete();
      renderFlash(
        data.success ? { notice: data.notice } : { alert: data.alert },
      );
    });
  }
}

export default Article;
