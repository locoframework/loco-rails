import Utils from '../utils'
import I18n from '../i18n'
import Env from '../env'

class Form
  constructor: (opts = {}) ->
    @formId = opts.id
    @obj = opts.for
    @initObj = if opts.initObj? and opts.initObj then true else false
    @delegator = opts.delegator
    @callbackSuccess = opts.callbackSuccess
    @callbackFailure = opts.callbackFailure
    @callbackActive = opts.callbackActive
    @form = this._findForm()
    @submit = null
    @submitVal = null
    if @form?
      @submit = @form.querySelector '[type="submit"]'
    if @submit?
      @submitVal = @submit.value
    @locale = Env.loco.getLocale()

  getObj: -> @obj

  render: ->
    if @initObj
      this._assignAttribs()
      this._handle()
    else if @form?
      this.fill()
      this._handle()

  fill: (attr = null) ->
    return null if not @obj?
    return null if not @obj.constructor.attributes?
    attributes = {}
    if attr?
      attributes[attr] = null
    else
      attributes = @obj.constructor.attributes
    for name, _ of attributes
      remoteName = @obj.getAttrRemoteName name
      query = @form.querySelector "[data-attr=#{remoteName}]"
      continue if query is null
      formEl = query.querySelectorAll "input,textarea,select"
      continue if formEl.length is 0
      if formEl.length is 1
        formEl[0].value = @obj[name]
        continue
      uniqInputTypes = Utils.Array.uniq Utils.Array.map formEl, (e) -> e.getAttribute 'type'
      if uniqInputTypes.length is 1 and uniqInputTypes[0] is 'radio'
        radioEl = Utils.Collection.find formEl, (e) => e.value is String(@obj[name])
        if radioEl?
          radioEl.checked = true
          continue
      if formEl[0].getAttribute("type") isnt "hidden" and formEl[formEl.length - 1].getAttribute('type') isnt "checkbox"
        continue
      formEl[formEl.length - 1].checked = Boolean(@obj[name])

  _findForm: ->
    return document.getElementById("#{@formId}") if @formId?
    if @obj?
      objName = @obj.getIdentity().toLowerCase()
      if @obj.id?
        document.getElementById "edit_#{objName}_#{@obj.id}"
      else
        document.getElementById "new_#{objName}"

  _handle: ->
    @form.addEventListener 'submit', (e) =>
      e.preventDefault()
      return if not this._canBeSubmitted()
      if not @obj?
        this._submitForm()
        return
      this._assignAttribs()
      this._hideErrors()
      if @obj.isInvalid()
        this._renderErrors()
        @delegator[@callbackFailure]() if @callbackFailure?
        return
      this._submittingForm false
      clearForm = if @obj.id? then false else true
      @obj.save()
      .then (data) =>
        this._alwaysAfterRequest()
        if data.success
          this._handleSuccess data, clearForm
        else
          @delegator[@callbackFailure]() if @callbackFailure?
          this._renderErrors()
      .catch (err) => this._connectionError()

  _canBeSubmitted: ->
    return true unless @submit?
    return false if Utils.Dom.hasClass @submit, 'active'
    return false if Utils.Dom.hasClass @submit, 'success'
    return false if Utils.Dom.hasClass @submit, 'failure'
    true

  _submitForm: ->
    this._submittingForm()
    url = @form.getAttribute('action') + '.json'
    data = new FormData @form
    req = new XMLHttpRequest()
    req.open 'POST', url
    req.setRequestHeader "X-CSRF-Token", document.querySelector("meta[name='csrf-token']")?.content
    req.onload = (e) =>
      this._alwaysAfterRequest()
      @submit.blur() if @submit?
      if e.target.status >= 200 and e.target.status < 400
        data = JSON.parse e.target.response
        if data.success
          this._handleSuccess data, @form.getAttribute("method") is "POST"
        else
          this._renderErrors data.errors
       else if e.target.status >= 500
         this._connectionError()
    req.onerror = =>
      this._alwaysAfterRequest()
      @submit.blur() if @submit?
      this._connectionError()
    req.send data

  _handleSuccess: (data, clearForm = true) ->
    val = data.flash?.success ? I18n[@locale].ui.form.success
    if @submit?
      Utils.Dom.addClass @submit, 'success'
      @submit.value = val
    if data.access_token?
      Env.loco.getWire().setToken data.access_token
    if @callbackSuccess?
      if data.data?
        @delegator[@callbackSuccess](data.data)
      else
        @delegator[@callbackSuccess]()
      return
    setTimeout =>
      if @submit?
        @submit.disabled = false
        Utils.Dom.removeClass @submit, 'success'
        @submit.value = @submitVal
      selector = ":not([data-loco-not-clear=true])"
      if clearForm
        nodes = @form.querySelectorAll "input:not([type='submit'])#{selector}, textarea#{selector}"
        for node in nodes
          node.value = ''
    , 5000

  _renderErrors: (remoteErrors = null) ->
    return if @obj? and not @obj.errors?
    return if not @obj? and not remoteErrors?
    data = if remoteErrors? then remoteErrors else @obj.errors
    for attrib, errors of data
      remoteName = if @obj? then @obj.getAttrRemoteName(attrib) else attrib
      if remoteName? and attrib isnt "base"
        # be aware of invalid elements's nesting e.g. "div" inside of "p"
        query = @form.querySelector "[data-attr=#{remoteName}]"
        continue if query is null
        nodes = query.querySelectorAll ".errors[data-for=#{remoteName}]"
        continue if nodes.length is 0
        for node in nodes
          node.textContent = errors[0]
        continue
      if attrib is "base" and errors.length > 0
        nodes = document.querySelectorAll ".errors[data-for='base']"
        if nodes.length is 1
          nodes[0].textContent = errors[0]
        else if @submit?
          @submit.value = errors[0]
    if @submit?
      if @submit.value is @submitVal or @submit.value is I18n[@locale].ui.form.sending
        @submit.value = I18n[@locale].ui.form.errors.invalid_data
      Utils.Dom.addClass @submit, 'failure'
    this._showErrors()
    setTimeout =>
      if @submit?
        @submit.disabled = false
        Utils.Dom.removeClass @submit, 'failure'
        @submit.value = @submitVal
      for node in @form.querySelectorAll('input.invalid, textarea.invalid, select.invalid')
        Utils.Dom.removeClass node, 'invalid'
    , 1000

  _assignAttribs: ->
    return null if not @obj.constructor.attributes?
    for name, _ of @obj.constructor.attributes
      remoteName = @obj.getAttrRemoteName name
      query = @form.querySelector "[data-attr=#{remoteName}]"
      continue if query is null
      formEl = query.querySelectorAll "input,textarea,select"
      continue if formEl.length is 0
      if formEl.length is 1
        @obj.assignAttr name, formEl[0].value
        continue
      uniqInputTypes = Utils.Array.uniq Utils.Array.map formEl, (e) -> e.getAttribute 'type'
      if uniqInputTypes.length is 1 and uniqInputTypes[0] is 'radio'
        radioEl = Utils.Collection.find formEl, (e) => e.checked is true
        if radioEl?
          @obj.assignAttr name, radioEl.value
          continue
      if formEl[0].getAttribute("type") isnt "hidden" and formEl[formEl.length - 1].getAttribute('type') isnt "checkbox"
        continue
      if formEl[formEl.length - 1].checked is true
        @obj.assignAttr name, formEl[formEl.length - 1].value
      else
        @obj.assignAttr name, formEl[0].value

  _hideErrors: ->
    for e in @form.querySelectorAll('.errors')
      if e.textContent.trim().length > 0
        e.textContent = ''
        e.style.display = 'none'

  _showErrors: ->
    for e in @form.querySelectorAll('.errors')
      if e.textContent.trim().length > 0
        e.style.display = 'block'

  _submittingForm: (hideErrors = true) ->
    if @submit?
      Utils.Dom.removeClass @submit, 'success'
      Utils.Dom.removeClass @submit, 'failure'
      Utils.Dom.addClass @submit, 'active'
      @submit.value = I18n[@locale].ui.form.sending
    @delegator[@callbackActive]() if @callbackActive?
    this._hideErrors() if hideErrors

  _connectionError: ->
    return unless @submit?
    Utils.Dom.removeClass @submit, 'active'
    Utils.Dom.addClass @submit, 'failure'
    @submit.value = I18n[@locale].ui.form.errors.connection
    setTimeout =>
      @submit.disabled = false
      Utils.Dom.removeClass @submit, 'failure'
      @submit.value = @submitVal
    , 3000

  _alwaysAfterRequest: ->
    return unless @submit?
    Utils.Dom.removeClass @submit, 'active'

export default Form