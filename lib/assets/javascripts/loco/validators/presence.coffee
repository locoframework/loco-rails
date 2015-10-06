class App.Validators.Presence extends App.Validators.Base
  constructor: -> super

  validate: ->
    return true if @val? and @val.length > 0
    this._addErrorMessage()
    false

  _addErrorMessage: ->
    message = "can't be blank"
    @obj.addErrorMessage message, for: @attr
