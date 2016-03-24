describe "App.Wire", ->
  beforeEach ->
    @wire = App.Env.loco.getWire()

  it "sets token correctly", ->
    @wire.setToken "123qweasdzxc"
    expect(@wire._requestParams()).toEqual {synced_at: null, token: "123qweasdzxc"}

  describe '#setPollingTime', ->
    it "can change polling time", ->
      expect(@wire.getPollingTime()).toEqual 3000
      pollingInterval = @wire.getPollingInterval()
      @wire.setPollingTime 10000
      expect(@wire.getPollingTime()).toEqual 10000
      expect(@wire.getPollingInterval()).not.toEqual pollingInterval

  describe "#_processNotification", ->
    it "returns if imap is empty", ->
      result = @wire._processNotification ["Article", 1, "created", {id: 1}]
      expect(result).toBe undefined

  describe "#_getURL", ->
    it "returns url with choosen protocol", ->
      @wire.setSSL true
      [protocol] = @wire._getURL().split '/'
      expect(protocol).toEqual 'https:'