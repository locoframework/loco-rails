class App.UI.Form
  constructor: (opts = {}) ->
    @formId = opts.id
    @obj = opts.for
    @initObj = if opts.initObj? and opts.initObj then true else false
    @delegator = opts.delegator
    @callbackSuccess = opts.callbackSuccess
    @callbackActive = opts.callbackActive
    @form = this._findForm()
    @submit = @form.find ':submit'
    @submitVal = @submit.val()
    @errorsShowHideDuration = if opts.errorsShowHideDuration? then opts.errorsShowHideDuration else 200
    @hideErrorFunc = if opts.hideErrorFunc? then opts.hideErrorFunc else 'slideUp'
    @showErrorFunc = if opts.showErrorFunc? then opts.showErrorFunc else 'slideDown'

  render: ->
    this._findForm()
    this._assignAttribs() if @initObj
    this._handle()

  getObj: -> @obj

  _findForm: ->
    @form = $("##{@formId}") if @formId?
    if @obj?
      objName = @obj.getIdentity().toLowerCase()
      @form = if @obj.id? then $("#edit_#{objName}_#{@obj.id}") else $("#new_#{objName}")

  _handle: ->
    @form.on 'submit', (e) =>
      e.preventDefault()
      return if not this._canBeSubmitted()
      if not @obj?
        this._submitForm()
        return
      this._hideErrors()
      this._assignAttribs()
      if not @obj.isValid()
        this._renderErrors()
        return
      this._submittingForm false
      clearForm = if @obj.id? then false else true
      @obj.save (data) =>
        if data.success
          this._handleSuccess data, clearForm
        else
          this._renderErrors()

  _canBeSubmitted: ->
    return false if @submit.hasClass 'active'
    return false if @submit.hasClass 'success'
    return false if @submit.hasClass 'failure'
    true

  _submitForm: ->
    this._submittingForm()
    url = @form.attr('action') + '.json'
    jqxhr = $.post url, @form.serialize()
    jqxhr.always => @submit.removeClass('active').blur()
    jqxhr.fail => @submit.val @submitVal
    jqxhr.done (data) =>
      if data.success
        this._handleSuccess data, @form.attr("method") is "POST"
      else
        this._renderErrors data.errors

  _handleSuccess: (data, clearForm = true) ->
    val = if data.flash? then data.flash.success else "Success"
    @submit.removeClass("active").addClass('success').val val
    if @callbackSuccess?
      if data.data?
        @delegator[@callbackSuccess](data.data)
      else
        @delegator[@callbackSuccess]()
      return
    setTimeout =>
      @submit.removeClass('success').val @submitVal
      selector = ":not([data-loco-not-clear=true])"
      if clearForm
        @form.find("input:not([type='submit'])#{selector}, textarea#{selector}").val ''
    , 5000

  _renderErrors: (remoteErrors = null) ->
    return if @obj? and not @obj.errors?
    return if not @obj? and not remoteErrors?
    data = if remoteErrors? then remoteErrors else @obj.errors
    for attrib, errors of data
      remoteName = if @obj? then @obj.getRemoteName(attrib) else attrib
      if remoteName? and attrib isnt "base"
        # be aware of invalid elements's nesting e.g. "div" inside of "p"
        @form.find("[data-attr=#{remoteName}]").find(".errors[data-for=#{remoteName}]").text errors[0]
        continue
      if attrib is "base" and errors.length > 0
        if $(".errors[data-for='base']").length is 1
          $(".errors[data-for='base']").text errors[0]
        else
          @submit.val errors[0]
    if @submit.val() is @submitVal or @submit.val() is "Sending..."
      @submit.val "Invalid data"
    @submit.removeClass("active").addClass 'failure'
    this._showErrors()
    setTimeout =>
      @submit.removeClass('failure').val @submitVal
      @form.find('input.invalid, textarea.invalid, select.invalid').removeClass 'invalid'
    , 1000

  _assignAttribs: ->
    return null if not @obj.constructor.attributes?
    for name, _ of @obj.constructor.attributes
      remoteName = @obj.getRemoteName name
      formEl = @form.find("[data-attr=#{remoteName}]").find("input,textarea,select").first()
      continue if formEl.length isnt 1
      @obj[name] = formEl.val()

  _hideErrors: ->
    @form.find('.errors').each (index, e) =>
      if $(e).text().trim().length > 0
        $(e).text ""
        $(e).velocity @hideErrorFunc, @errorsShowHideDuration

  _showErrors: ->
    @form.find('.errors').each (index, e) =>
      if $(e).text().trim().length > 0
        $(e).velocity @showErrorFunc, @errorsShowHideDuration

  _submittingForm: (hideErrors = true) ->
    @submit.removeClass('success').removeClass('failure').addClass('active').val "Sending..."
    @delegator[@callbackActive]() if @callbackActive?
    this._hideErrors() if hideErrors