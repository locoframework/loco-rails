import Base from './base.coffee'
import I18n from '../i18n'
import Config from '../config'

class Presence extends Base
  @identity = "Presence"

  constructor: -> super()

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
      I18n[Config.locale].errors.messages.blank
    @obj.addErrorMessage message, for: @attr

export default Presence