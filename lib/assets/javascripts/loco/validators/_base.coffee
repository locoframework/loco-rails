class App.Validators.Base
  @sharedInstances = {}

  @instance: (obj, attr, opts) ->
    validatorName = this.name
    if not @sharedInstances[validatorName]?
      @sharedInstances[validatorName] = new App.Validators[validatorName]
    sharedInstance = @sharedInstances[validatorName]
    sharedInstance.assignAttribs obj, attr, opts
    return sharedInstance

  constructor: ->
    @obj = null
    @attr = null
    @val = null
    @opts = null

  assignAttribs: (obj, attr, opts) ->
    @obj = obj
    @attr = attr
    @val = @obj[@attr]
    @opts = opts