import { Models } from "loco-js"

class Article extends Models.Base
  @identity = "Article"
  @resources =
    url: '/user/articles', paginate: {per: 5}
    main:
      url: '/articles', paginate: {per: 3}
    admin:
      url: '/admin/articles', paginate: {per: 4}

  @attributes =
    title:
      validations:
        presence: true
        length: {within: [3, 255]}
    content:
      validations:
        presence: true
        length: {minimum: 100}
      remoteName: "text"
    createdAt:
      type: "Date"
      remoteName: "created_at"
    updatedAt:
      type: "Date"
      remoteName: "updated_at"
    commentsCount:
      type: "Int"
      remoteName: "comments_count"
    publishedAt:
      type: "Date"
      remoteName: "published_at"
    published: {}
    adminReview:
      remoteName: "admin_review"
    adminRate:
      type: "Int"
      remoteName: "admin_rate"
    categoryId:
      type: "Int"
      remoteName: "category_id"
    adminReviewStartedAt:
      remoteName: "admin_review_started_at"

  @receivedSignal: (signal, data) ->

  @validate = ["vulgarityLevel"]

  constructor: (data) ->
    super data
    @published = if @publishedAt? then true else false

  receivedSignal: (signal, data) ->

  vulgarityLevel: ->
    if (this.title? and /fuck/i.exec(this.title)) or (this.content? and /fuck/i.exec(this.content))
      this.addErrorMessage "Article contains strong language.", for: 'base'

  setDefaultValuesForAdminReview: ->
    @adminRate ?= 3
    @categoryId ?= 6
    @adminReviewStartedAt = Date.now()

export default Article
