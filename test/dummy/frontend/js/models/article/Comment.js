import { Models } from "loco-js-model";

class Comment extends Models.Base {
  static identity = "Article.Comment";

  static remoteName = "Comment";

  static resources = {
    url: "/user/articles/:articleId/comments",
    paginate: { per: 10 },
    main: {
      url: "/articles/:articleId/comments",
      paginate: { per: 5, param: "page-num" },
    },
    admin: {
      url: "/admin/articles/:articleId/comments",
      paginate: { per: 5 },
    },
  };

  static attributes = {
    author: {
      validations: {
        presence: true,
      },
    },
    text: {
      validations: {
        presence: true,
        vulgarity: true,
      },
    },
    articleId: {
      type: "Int",
      validations: {
        presence: true,
      },
      remoteName: "article_id",
    },
    createdAt: {
      type: "Date",
      remoteName: "created_at",
    },
    updatedAt: {
      type: "Date",
      remoteName: "updated_at",
    },
    emotion: {
      type: "Int",
    },
    pinned: {
      type: "Boolean",
    },
    adminRate: {
      type: "Int",
      remoteName: "admin_rate",
    },
    approved: {
      type: "Boolean",
    },
  };

  constructor(data) {
    super(data);
  }
}

export default Comment;
