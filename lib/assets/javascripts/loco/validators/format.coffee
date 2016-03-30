class App.Validators.Format extends App.Validators.Base
  constructor: -> super

  validate: ->
    match = @opts.with.exec @val
    return if match?
    this._addErrorMessage()

  _addErrorMessage: ->
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.invalid
    @obj.addErrorMessage message, for: @attr