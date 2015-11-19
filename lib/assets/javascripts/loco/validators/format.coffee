class App.Validators.Format extends App.Validators.Base
  constructor: -> super

  validate: ->
    match = @opts.with.exec @val
    return true if match?
    this._addErrorMessage()
    false

  _addErrorMessage: ->
    message = "is invalid"
    @obj.addErrorMessage message, for: @attr