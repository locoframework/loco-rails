class App.Validators.Confirmation extends App.Validators.Base
  constructor: -> super

  validate: ->
    properVal = @obj[this._properAttr()]
    return if @val? and properVal? and @val is properVal
    this._addErrorMessage()

  _addErrorMessage: ->
    defaultAttrName = @attr.charAt(0).toUpperCase() + @attr.slice(1)
    attrNames = App.I18n[App.Env.loco.getLocale()].attributes[@obj.getIdentity()]
    attrName = (attrNames and attrNames[@attr]) || defaultAttrName
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.confirmation
    message = message.replace '%{attribute}', attrName
    @obj.addErrorMessage message, for: this._properAttr()

  _properAttr: -> "#{@attr}Confirmation"