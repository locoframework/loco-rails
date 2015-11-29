class App.Models.Article extends App.Models.Base
  @resources =
    url: '/user/articles', paginate: {per: 5}
    main:
      url: '/articles', paginate: {per: 3}

  @attributes =
    title:
      validations:
        presence: true
        length: {minimum: 3, maximum: 255}
    content:
      validations:
        presence: true
        length: {min: 100}
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

  @receivedSignal: (signal, data) ->

  @validate = ["vulgarityLevel"]

  constructor: (data) -> super data

  receivedSignal: (signal, data) ->

  vulgarityLevel: ->
    if (this.title? and /fuck/i.exec(this.title)) or (this.content? and /fuck/i.exec(this.content))
      this.addErrorMessage "Article contains strong language.", for: 'base'