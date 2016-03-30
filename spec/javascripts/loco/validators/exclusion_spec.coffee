describe 'App.Validators.Exclusion', ->
  beforeEach ->
    @dummy = new App.Models.Dummy author: 'admin'

  afterEach -> App.Env.loco.setLocale 'en'

  it 'adds error if value is in an array', ->
    @dummy.isValid()
    expect(@dummy.errors.author[0]).toEqual "is reserved"

  it 'is valid if value is not in an array', ->
    @dummy.author = 'David'
    expect(@dummy.isValid()).toBe true

  it 'supports i18n', ->
    App.Env.loco.setLocale 'pl'
    @dummy.isValid()
    expect(@dummy.errors.author[0]).toEqual "jest zarezerwowane"