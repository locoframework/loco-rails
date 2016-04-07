class App.Validators.Absence extends App.Validators.Base
  constructor: -> super

  validate: ->
    switch typeof @val
      when 'string'
        return if @val? and @val.length is 0
      else
        return if not @val?
    this._addErrorMessage()

  _addErrorMessage: ->
    message = if @opts.message?
      @opts.message
    else
      App.I18n[App.Env.loco.getLocale()].errors.messages.present
    @obj.addErrorMessage message, for: @attr
