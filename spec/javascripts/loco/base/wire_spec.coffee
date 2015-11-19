describe "App.Wire", ->
  beforeEach ->
    @wire = App.Env.loco.getWire()

  it "sets token correctly", ->
    @wire.setToken "123qweasdzxc"
    expect(@wire._requestParams()).toEqual {synced_at: null, token: "123qweasdzxc"}

  describe "#_processNotification", ->
    it "returns if imap is empty", ->
      result = @wire._processNotification ["Article", 1, "created", {id: 1}]
      expect(result).toBe undefined