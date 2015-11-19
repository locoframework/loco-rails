class App.Validators.Presence extends App.Validators.Base
  constructor: -> super

  validate: ->
    switch typeof @val
      when 'string'
        return true if @val? and @val.length > 0
      else
        return true if @val?
    this._addErrorMessage()
    false

  _addErrorMessage: ->
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.blank
    @obj.addErrorMessage message, for: @attr
