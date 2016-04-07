class App.Validators.Inclusion extends App.Validators.Base
  constructor: -> super

  validate: ->
    set = @opts.in or @opts.within or []
    return if set.indexOf(@val) isnt -1
    this._addErrorMessage()

  _addErrorMessage: ->
    message = if @opts.message?
      @opts.message
    else
      App.I18n[App.Env.loco.getLocale()].errors.messages.inclusion
    @obj.addErrorMessage message, for: @attr
