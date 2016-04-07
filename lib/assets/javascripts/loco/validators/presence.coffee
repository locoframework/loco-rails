class App.Validators.Presence extends App.Validators.Base
  constructor: -> super

  validate: ->
    switch typeof @val
      when 'string'
        return if @val? and @val.length > 0
      else
        return if @val?
    this._addErrorMessage()

  _addErrorMessage: ->
    message = if @opts.message?
      @opts.message
    else
      App.I18n[App.Env.loco.getLocale()].errors.messages.blank
    @obj.addErrorMessage message, for: @attr
