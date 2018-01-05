import Base from './base.coffee'
import I18n from '../i18n'
import Config from '../config'

class Numericality extends Base
  @identity = "Numericality"

  constructor: -> super()

  validate: ->
    if isNaN @val
      this._addNaNErrorMessage()
    else if @opts.only_integer? and Number(@val) isnt parseInt(@val)
      this._addIntErrorMessage()
    else if @opts.greater_than? and Number(@val) <= @opts.greater_than
      this._addGreatherThanErrorMessage()
    else if @opts.greater_than_or_equal_to? and Number(@val) < @opts.greater_than_or_equal_to
      this._addGreatherThanOrEqualToErrorMessage()
    else if @opts.equal_to? and Number(@val) isnt @opts.equal_to
      this._addEqualToErrorMessage()
    else if @opts.less_than? and Number(@val) >= @opts.less_than
      this._addLessThanErrorMessage()
    else if @opts.less_than_or_equal_to? and Number(@val) > @opts.less_than_or_equal_to
      this._addLessThanOrEqualToErrorMessage()
    else if @opts.other_than? and Number(@val) is @opts.other_than
      this._addOtherThanErrorMessage()
    else if @opts.odd? and Number(@val) % 2 isnt 1
      this._addOddErrorMessage()
    else if @opts.even? and Number(@val) % 2 isnt 0
      this._addEvenErrorMessage()

  _addNaNErrorMessage: ->
    message = if @opts.message?
      @opts.message
    else
      I18n[Config.locale].errors.messages.not_a_number
    @obj.addErrorMessage message, for: @attr

  _addIntErrorMessage: ->
    message = I18n[Config.locale].errors.messages.not_an_integer
    @obj.addErrorMessage message, for: @attr

  _addGreatherThanErrorMessage: ->
    message = I18n[Config.locale].errors.messages.greater_than
    message = message.replace '%{count}', @opts.greater_than
    @obj.addErrorMessage message, for: @attr

  _addGreatherThanOrEqualToErrorMessage: ->
    message = I18n[Config.locale].errors.messages.greater_than_or_equal_to
    message = message.replace '%{count}', @opts.greater_than_or_equal_to
    @obj.addErrorMessage message, for: @attr

  _addEqualToErrorMessage: ->
    message = I18n[Config.locale].errors.messages.equal_to
    message = message.replace '%{count}', @opts.equal_to
    @obj.addErrorMessage message, for: @attr

  _addLessThanErrorMessage: ->
    message = I18n[Config.locale].errors.messages.less_than
    message = message.replace '%{count}', @opts.less_than
    @obj.addErrorMessage message, for: @attr

  _addLessThanOrEqualToErrorMessage: ->
    message = I18n[Config.locale].errors.messages.less_than_or_equal_to
    message = message.replace '%{count}', @opts.less_than_or_equal_to
    @obj.addErrorMessage message, for: @attr

  _addOtherThanErrorMessage: ->
    message = I18n[Config.locale].errors.messages.other_than
    message = message.replace '%{count}', @opts.other_than
    @obj.addErrorMessage message, for: @attr

  _addOddErrorMessage: ->
    message = I18n[Config.locale].errors.messages.odd
    @obj.addErrorMessage message, for: @attr

  _addEvenErrorMessage: ->
    message = I18n[Config.locale].errors.messages.even
    @obj.addErrorMessage message, for: @attr

export default Numericality