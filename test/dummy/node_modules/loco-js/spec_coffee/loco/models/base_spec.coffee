describe 'App.Models.Base', ->
  beforeEach ->
    jasmine.Ajax.install()

  afterEach ->
    jasmine.Ajax.uninstall()

  it 'does not send param if was used in URL', ->
    App.Models.Article.Comment.all {articleId: 1}, (comments) ->
    expect(jasmine.Ajax.requests.mostRecent().url).toBe '/user/articles/1/comments?page=1'

  describe "attribute types", ->
    it 'can be Number', ->
      article = new App.Models.Article adminReviewStartedAt: '1464490570.0260842'
      expect(article.adminReviewStartedAt).toEqual 1464490570.0260842

    it 'can be Float', ->
      article = new App.Models.Article adminRate: '  8.33 aaa '
      expect(article.adminRate).toEqual 8.33

    it 'can be String', ->
      article = new App.Models.Article title: 12.33
      expect(article.title).toEqual '12.33'

  describe 'validation', ->
    it 'allows custom validations', ->
      article = new App.Models.Article content: 'Some words.. and fUCk!'
      expect(article.isInvalid()).toBe true
      expect(article.errors.base[0]).toEqual 'Article contains strong language.'

    it 'supports conditional validation', ->
      dummy = new App.Models.Dummy dumbAttrib5: 'KRAKOW'
      dummy.isValid()
      expect(dummy.errors.dumbAttrib5[0]).toEqual 'is invalid'
      dummy.dumbAttrib5 = 'KRK'
      dummy.isValid()
      expect(dummy.errors.dumbAttrib5).toBe undefined

  describe '#save', ->
    it 'properly builds URL for nested models', ->
      comment = new App.Models.Article.Comment articleId: 1, author: 'Joe Doe', text: 'foo bar baz'
      comment.save()
      expect(jasmine.Ajax.requests.mostRecent().url).toBe '/user/articles/1/comments'

  describe '#serialize', ->
    it "sets proper key's name for nested models", ->
      comment = new App.Models.Article.Comment articleId: 1, author: 'Joe Doe', text: 'foo bar baz'
      expect(comment.serialize()['comment']).not.toBe(undefined)

  describe '#assignAttr', ->
    it 'assigns Boolean values', ->
      comment = new App.Models.Article.Comment
      comment.assignAttr 'approved', true
      expect(comment.approved).toEqual true

    it 'converts to Boolean values', ->
      comment = new App.Models.Article.Comment
      comment.assignAttr 'approved', '0'
      expect(comment.approved).toEqual false
