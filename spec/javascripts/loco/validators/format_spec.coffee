describe 'App.Validators.Format', ->
  beforeEach ->
    @user = new App.Models.User email: 'joe.doe.com'

  afterEach -> App.Env.loco.setLocale 'en'

  it 'validates format', ->
    @user.isValid()
    expect(@user.errors.email[0]).toEqual "is invalid"

  it 'supports i18n', ->
    App.Env.loco.setLocale 'pl'
    @user.isValid()
    expect(@user.errors.email[0]).toEqual "jest nieprawidłowe"
