import { Env, I18n, Validators } from "loco-js";

class Vulgarity extends Validators.Base
  @identity = 'Vulgarity'

  constructor: -> super

  validate: ->
    return if not @val?
    switch typeof @val
      when 'string'
        vulgarWord = this._getVulgarWord()
        if ///#{vulgarWord}///i.exec @val
          this._addErrorMessage()
        else
          return
      else
        throw new TypeError "Vulgarity validator is applicable only for strings and #{@attr} isn't."

  _addErrorMessage: ->
    message = I18n[Env.loco.getLocale()].errors.messages.vulgarity
    @obj.addErrorMessage message, for: @attr

  _getVulgarWord: ->
    switch Env.loco.getLocale()
      when 'pl' then 'kurwa'
      when 'en' then 'fuck'

export default Vulgarity
