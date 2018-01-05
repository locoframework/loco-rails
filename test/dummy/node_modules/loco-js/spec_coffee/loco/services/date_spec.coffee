describe "App.Services.Date", ->
  beforeEach ->
    date = new Date 2015, 10, 8, 14, 12, 30, 30  # Nov
    @service = new App.Services.Date date

  describe "#toString", ->
    it "supports default format", ->
      expect(@service.toString()).toEqual '2015-11-08'

    it "supports short format", ->
      expect(@service.toString 'short').toEqual 'Nov 08'

    it "supports long format", ->
      expect(@service.toString 'long').toEqual 'November 08, 2015'
