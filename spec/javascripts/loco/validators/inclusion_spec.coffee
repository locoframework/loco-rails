describe 'App.Validators.Inclusion', ->
  beforeEach ->
    @dummy = new App.Models.Dummy rate: 'decent'

  afterEach -> App.Env.loco.setLocale 'en'

  it 'adds error if value is not available in an array', ->
    @dummy.isValid()
    expect(@dummy.errors.rate[0]).toEqual "is not included in the list"

  it 'is valid if value is available in an array', ->
    @dummy.rate = 'good'
    @dummy.isValid()
    expect(@dummy.errors.rate).toBe undefined

  it 'supports i18n', ->
    App.Env.loco.setLocale 'pl'
    @dummy.isValid()
    expect(@dummy.errors.rate[0]).toEqual "nie znajduje się na liście dopuszczalnych wartości"

  it 'supports custom message', ->
    dcm = new App.Models.DummyCustomMsg rate: 'decent'
    dcm.isValid()
    expect(dcm.errors.rate[0]).toEqual 'value is not good'