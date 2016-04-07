describe 'App.Validators.Presence', ->
  beforeEach ->
    @article = new App.Models.Article title: ''

  afterEach -> App.Env.loco.setLocale 'en'

  it 'validates length if object is a string', ->
    @article.isValid()
    expect(@article.errors.title[0]).toEqual "can't be blank"

  it 'supports i18n', ->
    App.Env.loco.setLocale 'pl'
    @article.isValid()
    expect(@article.errors.title[0]).toEqual "nie może być puste"

  it 'supports custom message', ->
    dcm = new App.Models.DummyCustomMsg title: null
    dcm.isValid()
    expect(dcm.errors.title[0]).toEqual 'presence is required'