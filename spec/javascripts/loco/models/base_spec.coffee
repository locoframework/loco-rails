describe 'App.Models.Base', ->
  beforeEach ->
    jasmine.Ajax.install()

  afterEach ->
    jasmine.Ajax.uninstall()

  it 'does not send param if was used in URL', ->
    App.Models.Article.Comment.all {articleId: 1}, (comments) ->
    expect(jasmine.Ajax.requests.mostRecent().url).toBe '/user/articles/1/comments?page=1'

  describe '@validate', ->
    it 'allows custom validations', ->
      article = new App.Models.Article content: 'Some words.. and fUCk!'
      expect(article.isInvalid()).toBe true
      expect(article.errors.base[0]).toEqual 'Article contains strong language.'

  describe '#save', ->
    it 'properly builds URL for nested models', ->
      comment = new App.Models.Article.Comment articleId: 1, author: 'Joe Doe', text: 'foo bar baz'
      comment.save()
      expect(jasmine.Ajax.requests.mostRecent().url).toBe '/user/articles/1/comments'

  describe '#serialize', ->
    it "sets proper key's name for nested models", ->
      comment = new App.Models.Article.Comment articleId: 1, author: 'Joe Doe', text: 'foo bar baz'
      expect(comment.serialize()['comment']).not.toBe(undefined)