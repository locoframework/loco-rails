describe 'App.Models.Base', ->
  beforeEach ->
    jasmine.Ajax.install()

  afterEach ->
    jasmine.Ajax.uninstall()

  it 'does not send param if was used in URL', ->
    App.Models.Article.Comment.all {articleId: 1}, (comments) ->
    expect(jasmine.Ajax.requests.mostRecent().url).toBe '/user/articles/1/comments?page=1'

  describe '#save', ->
    it 'properly builds URL for nested models', ->
      comment = new App.Models.Article.Comment articleId: 1, author: 'Joe Doe', text: 'foo bar baz'
      comment.save()
      expect(jasmine.Ajax.requests.mostRecent().url).toBe '/user/articles/1/comments'

  describe '#serialize', ->
    it "sets proper key's name for nested models", ->
      comment = new App.Models.Article.Comment articleId: 1, author: 'Joe Doe', text: 'foo bar baz'
      expect(comment.serialize()['comment']).not.toBe(undefined)