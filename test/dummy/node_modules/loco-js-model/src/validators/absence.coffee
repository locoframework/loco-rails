import Base from './base.coffee'
import I18n from '../i18n'
import Config from '../config'

class Absence extends Base
  @identity = "Absence"

  constructor: -> super()

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
      I18n[Config.locale].errors.messages.present
    @obj.addErrorMessage message, for: @attr

export default Absence