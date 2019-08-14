import { Models } from "loco-js";

class Article extends Models.Base {
  static identity = "Article";

  static resources = {
    url: "/user/articles",
    paginate: { per: 5 },
    main: {
      url: "/articles",
      paginate: { per: 3 }
    },
    admin: {
      url: "/admin/articles",
      paginate: { per: 4 }
    }
  };

  static attributes = {
    title: {
      validations: {
        presence: true,
        length: { within: [3, 255] }
      }
    },
    content: {
      validations: {
        presence: true,
        length: { minimum: 100 }
      },
      remoteName: "text"
    },
    createdAt: {
      type: "Date",
      remoteName: "created_at"
    },
    updatedAt: {
      type: "Date",
      remoteName: "updated_at"
    },
    commentsCount: {
      type: "Int",
      remoteName: "comments_count"
    },
    publishedAt: {
      type: "Date",
      remoteName: "published_at"
    },
    published: {},
    adminReview: {
      remoteName: "admin_review"
    },
    adminRate: {
      type: "Int",
      remoteName: "admin_rate"
    },
    categoryId: {
      type: "Int",
      remoteName: "category_id"
    },
    adminReviewStartedAt: {
      remoteName: "admin_review_started_at"
    }
  };

  static validate = ["vulgarityLevel"];

  constructor(data) {
    super(data);
    this.published = this.publishedAt == null ? false : true;
  }

  vulgarityLevel() {
    if (
      (this.title != null && /fuck/i.exec(this.title)) ||
      (this.content != null && /fuck/i.exec(this.content))
    )
      this.addErrorMessage("Article contains strong language.", {
        for: "base"
      });
  }

  setDefaultValuesForAdminReview() {
    this.adminRate = this.adminRate == null ? 3 : this.adminRate;
    this.categoryId = this.categoryId == null ? 6 : this.categoryId;
    this.adminReviewStartedAt = Date.now();
  }
}

export default Article;
