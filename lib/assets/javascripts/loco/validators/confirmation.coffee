class App.Validators.Confirmation extends App.Validators.Base
  constructor: -> super

  validate: ->
    @properAttr = "#{@attr}Confirmation"
    properVal = @obj[@properAttr]
    return true if @val? and properVal? and @val is properVal
    this._addErrorMessage()
    false

  _addErrorMessage: ->
    console.log "TODO: implement I18n"
    # TODO: extend underscore with mixin
    attrName = @attr.charAt(0).toUpperCase() + @attr.slice(1)
    message = "doesn't match #{attrName}"
    @obj.addErrorMessage message, for: @properAttr
