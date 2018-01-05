describe 'App.Validators.Numericality', ->
  beforeEach ->
    @dummy = new App.Models.Dummy year: 'foo'
    @dcm = new App.Models.DummyCustomMsg year: 'foo'
    @currentYear = new Date().getFullYear()

  afterEach -> App.Env.loco.setLocale 'en'

  it 'is valid if int required and int is passed as string', ->
    @dummy.year = '1900'
    @dummy.isValid()
    expect(@dummy.errors.year).toBe undefined

  it 'supports custom message', ->
    @dcm.isValid()
    expect(@dcm.errors.year[0]).toEqual 'your number is not acceptable'

  describe 'i18n support (en)', ->

    it 'has message if not a number', ->
      @dummy.isValid()
      expect(@dummy.errors.year[0]).toEqual "is not a number"

    it 'has message if not an integer', ->
      @dummy.year = '231.23'
      @dummy.isValid()
      expect(@dummy.errors.year[0]).toEqual "must be an integer"

    it 'has message if value is not greather than specified value', ->
      @dummy.year = 1887
      @dummy.isValid()
      expect(@dummy.errors.year[0]).toEqual "must be greater than 1887"

    it 'has message if value is not greather than or equal to specified value', ->
      @dummy.releaseYear = 2015
      @dummy.isValid()
      expect(@dummy.errors.releaseYear[0]).toEqual "must be greater than or equal to #{@currentYear}"

    it 'has message if value is not equal to specified value', ->
      @dummy.dumbAttrib = 6
      @dummy.isValid()
      expect(@dummy.errors.dumbAttrib[0]).toEqual "must be equal to 5"

    it 'has message if value is not less than specified value', ->
      @dummy.releaseYear = 2101
      @dummy.isValid()
      expect(@dummy.errors.releaseYear[0]).toEqual "must be less than 2100"

    it 'has message if value is not less than or equal to specified value', ->
      @dummy.year = 2015
      @dummy.releaseYear = 2013
      @dummy.isValid()
      expect(@dummy.errors.year[0]).toEqual "must be less than or equal to 2013"

    it 'has message if value is not other than specified value', ->
      @dummy.releaseYear = 2098
      @dummy.isValid()
      expect(@dummy.errors.releaseYear[0]).toEqual "must be other than 2098"

    it 'has message if specified value is not odd', ->
      @dummy.dumbAttrib2 = '12'
      @dummy.isValid()
      expect(@dummy.errors.dumbAttrib2[0]).toEqual "must be odd"

    it 'has message if specified value is not even', ->
      @dummy.dumbAttrib3 = '12345'
      @dummy.isValid()
      expect(@dummy.errors.dumbAttrib3[0]).toEqual "must be even"

  describe 'i18n support (pl)', ->

    beforeEach -> App.Env.loco.setLocale 'pl'

    it 'has message if not a number', ->
      @dummy.isValid()
      expect(@dummy.errors.year[0]).toEqual "nie jest liczbą"

    it 'has message if not an integer', ->
      @dummy.year = 231.23
      @dummy.isValid()
      expect(@dummy.errors.year[0]).toEqual "musi być liczbą całkowitą"

    it 'has message if value is not greather than specified value', ->
      @dummy.year = 1887
      @dummy.isValid()
      expect(@dummy.errors.year[0]).toEqual "musi być większe od 1887"

    it 'has message if value is not greather than or equal to specified value', ->
      @dummy.releaseYear = 2015
      @dummy.isValid()
      expect(@dummy.errors.releaseYear[0]).toEqual "musi być większe lub równe #{@currentYear}"

    it 'has message if value is not equal to specified value', ->
      @dummy.dumbAttrib = 6
      @dummy.isValid()
      expect(@dummy.errors.dumbAttrib[0]).toEqual "musi być równe 5"

    it 'has message if value is not less than specified value', ->
      @dummy.releaseYear = 2101
      @dummy.isValid()
      expect(@dummy.errors.releaseYear[0]).toEqual "musi być mniejsze od 2100"

    it 'has message if value is not less than or equal to specified value', ->
      @dummy.year = 2015
      @dummy.releaseYear = 2013
      @dummy.isValid()
      expect(@dummy.errors.year[0]).toEqual "musi być mniejsze lub równe 2013"

    it 'has message if value is not other than specified value', ->
      @dummy.releaseYear = 2098
      @dummy.isValid()
      expect(@dummy.errors.releaseYear[0]).toEqual "musi być inna niż 2098"

    it 'has message if specified value is not odd', ->
      @dummy.dumbAttrib2 = '12'
      @dummy.isValid()
      expect(@dummy.errors.dumbAttrib2[0]).toEqual "musi być nieparzyste"

    it 'has message if specified value is not even', ->
      @dummy.dumbAttrib3 = '12345'
      @dummy.isValid()
      expect(@dummy.errors.dumbAttrib3[0]).toEqual "musi być parzyste"