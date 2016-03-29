class App.Validators.Length extends App.Validators.Base
  constructor: -> super

  validate: ->
    if not @val?
      return true
    message = if this._range()[0]? and this._range()[1]? and this._range()[0] is this._range()[1] and @val.length isnt this._range()[0]
      this._selectErrorMessage 'wrong_length', this._range()[0]
    else if this._range()[0]? and @val.length < this._range()[0]
      this._selectErrorMessage 'too_short', this._range()[0]
    else if this._range()[1]? and @val.length > this._range()[1]
      this._selectErrorMessage 'too_long', this._range()[1]
    else
      null
    return true if message is null
    @obj.addErrorMessage message, for: @attr

  _range: ->
    from = @opts.minimum or @opts.is or (@opts.within? and @opts.within[0]) or null
    to = @opts.maximum or @opts.is or (@opts.within? and @opts.within[1]) or null
    [from, to]

  _selectErrorMessage: (msg, val) ->
    if val is 1
      return App.I18n[App.Env.loco.getLocale()].errors.messages[msg].one
    message = null
    for variant in ['few', 'many']
      if this._checkVariant variant, val
        message = App.I18n[App.Env.loco.getLocale()].errors.messages[msg][variant]
        break
    if not message?
      message = App.I18n[App.Env.loco.getLocale()].errors.messages[msg].other
    if /%{count}/.exec message
      message = message.replace '%{count}', val
    message

  _checkVariant: (variant, val) ->
    return if not App.I18n[App.Env.loco.getLocale()].variants[variant]?
    App.I18n[App.Env.loco.getLocale()].variants[variant] val