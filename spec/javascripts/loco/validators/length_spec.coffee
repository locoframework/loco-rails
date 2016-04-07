describe 'App.Validators.Length', ->
  beforeEach ->
    @tooLongTitle = "Migrations are stored as files in the db/migrate directory, one for each migration class. The name of the file is of the form YYYYMMDDHHMMSS_create_products.rb, that is to say a UTC timestamp identifying the migration followed by an underscore followed by the name of the migration."
    @article = new App.Models.Article title: 'ab'

  afterEach -> App.Env.loco.setLocale 'en'

  describe 'i18n support (en)', ->

    describe 'too short', ->

      it "has message on variant 'one'", ->
        @dummy = new App.Models.Dummy title: ''
        @dummy.isValid()
        expect(@dummy.errors.title[0]).toEqual "is too short (minimum is 1 character)"

      it "has message on variant 'few'", ->
        @article.isValid()
        expect(@article.errors.title[0]).toEqual "is too short (minimum is 3 characters)"

      it "has message on variant 'many'", ->
        @article.isValid()
        expect(@article.errors.title[0]).toEqual "is too short (minimum is 3 characters)"

      it "has message on variant 'other'", ->
        @article.isValid()
        expect(@article.errors.title[0]).toEqual "is too short (minimum is 3 characters)"

    describe 'too long', ->

      it "has message on variant 'one'", ->
        @dummy = new App.Models.Dummy dumbAttrib: 'ab'
        @dummy.isValid()
        expect(@dummy.errors.dumbAttrib[0]).toEqual "is too long (maximum is 1 character)"

      it "has message on variant 'few'", ->
        @article.title = @tooLongTitle
        @article.isValid()
        expect(@article.errors.title[0]).toEqual "is too long (maximum is 255 characters)"

      it "has message on variant 'many'", ->
        @article.title = @tooLongTitle
        @article.isValid()
        expect(@article.errors.title[0]).toEqual "is too long (maximum is 255 characters)"

      it "has message on variant 'other'", ->
        @article.title = @tooLongTitle
        @article.isValid()
        expect(@article.errors.title[0]).toEqual "is too long (maximum is 255 characters)"

    describe 'wrong length', ->

      it "has message on variant 'one'", ->
        @dummy = new App.Models.Dummy letter: 'ab'
        @dummy.isValid()
        expect(@dummy.errors.letter[0]).toEqual "is the wrong length (should be 1 character)"

      it "has message on variant 'few'", ->
        @dummy = new App.Models.Dummy lang: 'a'
        @dummy.isValid()
        expect(@dummy.errors.lang[0]).toEqual "is the wrong length (should be 2 characters)"

      it "has message on variant 'many'", ->
        @dummy = new App.Models.Dummy lang: 'a'
        @dummy.isValid()
        expect(@dummy.errors.lang[0]).toEqual "is the wrong length (should be 2 characters)"

      it "has message on variant 'other'", ->
        @dummy = new App.Models.Dummy lang: 'a'
        @dummy.isValid()
        expect(@dummy.errors.lang[0]).toEqual "is the wrong length (should be 2 characters)"

  describe 'i18n support (pl)', ->

    beforeEach -> App.Env.loco.setLocale 'pl'

    describe 'too short', ->

      it "has message on variant 'one'", ->
        @dummy = new App.Models.Dummy title: ''
        @dummy.isValid()
        expect(@dummy.errors.title[0]).toEqual "jest za krótkie (przynajmniej jeden znak)"

      it "has message on variant 'few'", ->
        @article.isValid()
        expect(@article.errors.title[0]).toEqual "jest za krótkie (przynajmniej 3 znaki)"

      it "has message on variant 'many'", ->
        @dummy = new App.Models.Dummy shortDesc: 'abc'
        @dummy.isValid()
        expect(@dummy.errors.shortDesc[0]).toEqual "jest za krótkie (przynajmniej 10 znaków)"

      it "has message on variant 'other'", ->
        @dummy = new App.Models.Dummy shortDesc: 'abc'
        @dummy.isValid()
        expect(@dummy.errors.shortDesc[0]).toEqual "jest za krótkie (przynajmniej 10 znaków)"

    describe 'too long', ->

      it "has message on variant 'one'", ->
        @dummy = new App.Models.Dummy dumbAttrib: 'ab'
        @dummy.isValid()
        expect(@dummy.errors.dumbAttrib[0]).toEqual "jest za długie (maksymalnie jeden znak)"

      it "has message on variant 'few'", ->
        @dummy = new App.Models.Dummy dumbAttrib2: 'cdefgah'
        @dummy.isValid()
        expect(@dummy.errors.dumbAttrib2[0]).toEqual "jest za długie (maksymalnie 4 znaki)"

      it "has message on variant 'many'", ->
        @article.title = @tooLongTitle
        @article.isValid()
        expect(@article.errors.title[0]).toEqual "jest za długie (maksymalnie 255 znaków)"

      it "has message on variant 'other'", ->
        @article.title = @tooLongTitle
        @article.isValid()
        expect(@article.errors.title[0]).toEqual "jest za długie (maksymalnie 255 znaków)"

    describe 'wrong length', ->

      it "has message on variant 'one'", ->
        @dummy = new App.Models.Dummy letter: 'ab'
        @dummy.isValid()
        expect(@dummy.errors.letter[0]).toEqual "ma nieprawidłową długość (powinna wynosić jeden znak)"

      it "has message on variant 'few'", ->
        @dummy = new App.Models.Dummy lang: 'a'
        @dummy.isValid()
        expect(@dummy.errors.lang[0]).toEqual "ma nieprawidłową długość (powinna wynosić 2 znaki)"

      it "has message on variant 'many'", ->
        @dummy = new App.Models.Dummy dumbAttrib3: 'a'
        @dummy.isValid()
        expect(@dummy.errors.dumbAttrib3[0]).toEqual "ma nieprawidłową długość (powinna wynosić 5 znaków)"

      it "has message on variant 'other'", ->
        @dummy = new App.Models.Dummy dumbAttrib4: 'a'
        @dummy.isValid()
        expect(@dummy.errors.dumbAttrib4[0]).toEqual "ma nieprawidłową długość (powinna wynosić 100 znaków)"

  describe 'custom message support', ->

    beforeEach ->
      @dummy = new App.Models.DummyCustomMsg shortDesc: 'foo bar', lang: 'PLN'

    it 'has the same custom message for "minimum" violation', ->
      @dummy.isValid()
      expect(@dummy.errors.shortDesc[0]).toEqual 'length is bloody wrong'

    it 'has the same custom message for "maximum" violation', ->
      @dummy.shortDesc = @tooLongTitle
      @dummy.isValid()
      expect(@dummy.errors.shortDesc[0]).toEqual 'length is bloody wrong'

    it 'has the same custom message for "is" violation', ->
      @dummy.isValid()
      expect(@dummy.errors.lang[0]).toEqual 'length is not what I expect'