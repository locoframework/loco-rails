describe 'App.Validators.Confirmation', ->
  beforeEach ->
    @user = new App.Models.User password: 'secret', passwordConfirmation: 'sexret'

  afterEach -> App.Env.loco.setLocale 'en'

  it 'validates format', ->
    @user.isValid()
    expect(@user.errors.passwordConfirmation[0]).toEqual "doesn't match Password"

  it 'supports i18n', ->
    App.Env.loco.setLocale 'pl'
    @user.isValid()
    expect(@user.errors.passwordConfirmation[0]).toEqual "nie zgadza się z polem Hasło"

  it 'supports custom message', ->
    dummy = new App.Models.DummyCustomMsg accessPassword: 'secret'
    dummy.isValid()
    expect(dummy.errors.accessPasswordConfirmation[0]).toEqual 'different than confirmation'