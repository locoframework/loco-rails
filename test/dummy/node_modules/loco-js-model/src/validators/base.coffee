import Validators from '../validators'

class Base
  @sharedInstances = {}

  @instance: (obj, attr, opts) ->
    validatorName = @identity
    if not @sharedInstances[validatorName]?
      @sharedInstances[validatorName] = new Validators[validatorName]
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

export default Base