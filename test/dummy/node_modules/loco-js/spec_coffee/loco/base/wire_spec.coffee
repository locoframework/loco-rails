describe "App.Wire", ->
  beforeEach ->
    @wire = new App.Wire {}

  afterEach ->
    @wire.disconnect()

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

  describe "#processNotification", ->
    it "returns if imap is empty", ->
      result = @wire.processNotification ["Article", 1, "created", {id: 1}]
      expect(result).toBe undefined

  describe "#_getURL", ->
    it "returns url with choosen protocol", ->
      @wire.setSSL true
      [protocol] = @wire._getURL().split '/'
      expect(protocol).toEqual 'https:'

    it "return correct notifications's location", ->
      @wire.setLocation 'nc'
      [_, _, _, location] = @wire._getURL().split '/'
      expect(location).toEqual 'nc'

  describe "#setSize", ->
    it "can set max size of notifications", ->
      @wire.setSize 10
      expect(@wire.getSize()).toEqual 10