class App.Validators.Base
  @sharedInstances = {}

  @instance: (obj, attr) ->
    validatorName = this.name
    if not @sharedInstances[validatorName]?
      @sharedInstances[validatorName] = new App.Validators[validatorName]
    sharedInstance = @sharedInstances[validatorName]
    sharedInstance.assignAttribs obj, attr
    return sharedInstance

  constructor: ->
    @obj = null
    @attr = null
    @val = null

  assignAttribs: (obj, attr) ->
    @obj = obj
    @attr = attr
    @val = @obj[@attr]