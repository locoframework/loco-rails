class App.Models.Article.Comment extends App.Models.Base
  @identity = "Article.Comment"
  @remoteName = "Comment"
  @resources =
    url: '/user/articles/:articleId/comments', paginate: {per: 10}
    main:
      url: '/articles/:articleId/comments', paginate: {per: 5}

  @attributes =
    author:
      validations:
        presence: true
    text:
      validations:
        presence: true
        vulgarity: true
    articleId:
      type: "Int"
      validations:
        presence: true
      remoteName: "article_id"
    createdAt:
      type: "Date"
      remoteName: "created_at"
    updatedAt:
      type: "Date"
      remoteName: "updated_at"
    approved:
      type: "Boolean"

  constructor: (data) -> super data

  @receivedSignal: (signal, data) ->

  receivedSignal: (signal, data) ->
