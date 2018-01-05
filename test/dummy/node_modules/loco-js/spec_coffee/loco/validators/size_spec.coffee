describe 'App.Validators.Size', ->
  it "is alias for Length Validator", ->
    dummy = new App.Models.Dummy dumbAttrib5: ''
    dummy.isValid()
    expect(dummy.errors.dumbAttrib5[0]).toEqual "is too short (minimum is 1 character)"