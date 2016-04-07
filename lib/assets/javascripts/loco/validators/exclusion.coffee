class App.Validators.Exclusion extends App.Validators.Base
  constructor: -> super

  validate: ->
    set = @opts.in or @opts.within or []
    return if set.indexOf(@val) is -1
    this._addErrorMessage()

  _addErrorMessage: ->
    message = if @opts.message?
      @opts.message
    else
      App.I18n[App.Env.loco.getLocale()].errors.messages.exclusion
    @obj.addErrorMessage message, for: @attr
