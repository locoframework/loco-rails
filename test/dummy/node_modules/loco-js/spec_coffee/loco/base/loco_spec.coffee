describe "App.Loco", ->
  describe '#setProtocolWithHost', ->
    it "removes slash at the end", ->
      App.Env.loco.setProtocolWithHost 'https://localhost:3000/'
      expect(App.Env.loco.getProtocolWithHost()).toEqual 'https://localhost:3000'