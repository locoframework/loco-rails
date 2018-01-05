describe 'App.Views.Base', ->
  describe '#getDelegator', ->
    it "returns delegator", ->
      view = new App.Views.Layouts.User
      view.setDelegator 'foo'
      expect(view.getDelegator()).toEqual 'foo'