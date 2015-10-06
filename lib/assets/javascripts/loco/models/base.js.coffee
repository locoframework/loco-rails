class App.Models.Base
  # Ex.
  # class App.Models.Post extends App.Models.Base
  #   @identity = "Post"  # required for nested models e.g. App.Models.Post.Comment
  #
  #   @resourcesUrl = "/posts"  # optional
  #
  #   # deprecated
  #   @attrMapping = {created_at: "createdAt", updated_at: "updatedAt"}
  #
  #   # deprecated
  #   @attrTypes = {createdAt: "Date"}
  #
  #   @attributes =
  #     validatedAt:
  #       type: "Date"
  #       remoteName: "updated_at"
  #       validations:
  #         presence: true
  #
  #   @paginate = {per: 100, param: "page"}  # param is optional

  @all: (opts = {}, callback) -> @get "all", opts, callback

  @page: (i, opts = {}, successCallback, countCallback, reqOpts = {}) ->
    httpMethod = reqOpts.method || "GET"
    url = reqOpts.url || @__getResourcesUrl(opts)
    pageParam = if @paginate? and @paginate.param? then @paginate.param else "page"
    data = {}
    if reqOpts.data?
      for key, val of reqOpts.data
        data[key] = val
    data["#{pageParam}"] = i
    $.ajax({
      dataType: "json",
      method: httpMethod,
      url: url,
      data: data
    }).done (data) =>
      arr = []
      for record in data.resources
        obj = @__initSubclass record
        App.IdentityMap.add obj
        arr.push obj
      successCallback arr
      countCallback(data.count, arr) if countCallback?

  @find: (id, successCallback) ->
    urlParams = {}
    if typeof id is "object"
      urlParams = id
      id = id.id
      delete urlParams.id
    jqxhr = $.getJSON "#{@__getResourcesUrl(urlParams)}/#{id}", ->
    jqxhr.always ->
    jqxhr.fail ->
      successCallback null
      return false
    jqxhr.done (record) =>
      obj = @__initSubclass record
      App.IdentityMap.add obj
      successCallback obj
      return true

  @get: (action, opts, callback) -> @__send "GET", action, opts, callback
  @post: (action, opts, callback) -> @__send "POST", action, opts, callback
  @put: (action, opts, callback) -> @__send "PUT", action, opts, callback
  @delete: (action, opts, callback) -> @__send "DELETE", action, opts, callback

  @getIdentity: -> if @identity? then @identity else @name

  @getRemoteName: -> if @remoteName? then @remoteName else @name

  @getAttribRemoteName: (attrib) ->
    return null if not this.attributes?
    return null if not this.attributes[attrib]?
    return attrib if not this.attributes[attrib].remoteName?
    this.attributes[attrib].remoteName

  @getResourcesUrlParams: ->
    url = @__getResourcesUrl()
    regexp = /:(\w+)\/?/
    params = []
    while match = regexp.exec url
      params.push match[1]
      url = url.replace match[0], match[1]
    params

  @__getResourcesUrl: (opts = {}) ->
    return "/#{@getIdentity().toLowerCase()}s" if not @resourcesUrl?
    match = /:(\w+)\/?/.exec @resourcesUrl
    return @resourcesUrl if not match?
    return @resourcesUrl if not opts[match[1]]?
    @resourcesUrl.replace ":#{match[1]}", opts[match[1]]

  @__initSubclass: (params = {}) ->
    parts = @getIdentity().split "."
    return new App.Models[parts[0]] params if parts.length is 1
    new App.Models[parts[0]][parts[1]] params

  @__paginate: (opts, callback, reqOpts) ->
    perPage = if @paginate? and @paginate.per? then @paginate.per else null
    @page 1, opts, callback, (count, records) =>
      return if count <= perPage
      objs = App.IdentityMap.all @getIdentity()
      if objs? and objs.length is count
        ids = _.map records, (record) -> record.id
        callback objs.filter (obj) -> ids.indexOf(obj.id) is -1
        return
      max = parseInt count / perPage
      max += 1 if max isnt count / perPage
      return if max is 1
      data = @page 2, opts, callback, null, reqOpts
      return if max is 2
      for i in [3..max]
        func = (i) => data = data.then(=> @page i, opts, callback, null, reqOpts)
        func i
    , reqOpts

  @__send: (method, action, opts, callback) ->
    url = @__getResourcesUrl opts
    if action isnt "all"
      url = "#{url}/#{action}"
    reqOpts = {method: method, url: url, data: opts}
    @__paginate opts, callback, reqOpts

  constructor: (data) ->
    @id = null
    @errors = null
    this.__initAttributes() if this.constructor.attributes?
    this.__assignAttributes(data) if data?

  getIdentity: ->
    val = this.constructor.identity
    return val if val?
    this.constructor.name

  getRemoteName: (attr) ->
    return null if not this.constructor.attributes?
    return null if not this.constructor.attributes[attr]?
    this.constructor.attributes[attr].remoteName or attr

  attributes: ->
    attribs = {id: this.id}
    return attribs if not this.constructor.attributes?
    for name, _ of this.constructor.attributes
      attribs[name] = this[name]
    attribs

  isValid: ->
    return true if not this.constructor.attributes?
    valid = true
    @errors = null
    for name, config of this.constructor.attributes
      continue if not config.validations?
      for validationName, validationSettings of config.validations
        switch validationName
          when "presence"
            validatorValid = App.Validators.Presence.instance(this, name).validate()
            valid = false if not validatorValid
          else
            console.log "Warning! \"#{validationName}\" validator is not implemented!"
    return valid

  isEmpty: ->
    for name, val of this.attributes()
      return false if this[name] isnt null
    true

  addErrorMessage: (message, opts = {}) ->
    @errors = {} if not @errors?
    @errors[opts.for] = [] if not @errors[opts.for]?
    @errors[opts.for].push message

  save: (callback) ->
    return false if not this.isValid()
    jqxhr = $.ajax({
      method: if @id? then "PUT" else "POST",
      url: this.__getResourceUrl(),
      data: this.serialize()
    })
    jqxhr.always ->
    jqxhr.fail ->
    jqxhr.done (data) =>
      if data.success
        callback data
        return true
      this.__assignRemoteErrorMessages(data.errors) if data.errors?
      callback data
      return false

  serialize: ->
    return {} if not this.constructor.attributes?
    hash = {}
    mainKey = this.getIdentity().toLowerCase()
    hash[mainKey] = {}
    for attr, _ of this.constructor.attributes
      remoteName = this.getRemoteName attr
      hash[mainKey][remoteName] = this[attr]
    hash

  changes: ->
    result = {}
    currentObj = App.IdentityMap.find this.getIdentity(), this.id
    for name, val of this.attributes()
      if val isnt currentObj[name]
        continue if val.constructor is Date and currentObj[name] - val is 0
        result[name] = {is: currentObj[name], was: val} if val isnt currentObj[name]
    return result

  applyChanges: -> this[name] = vals.is for name, vals of this.changes()

  toKey: -> "#{this.getIdentity().toLowerCase()}_#{this.id}"

  get: (action, data, callback) -> this.__send "GET", action, data, callback
  post: (action, data, callback) -> this.__send "POST", action, data, callback
  put: (action, data, callback) -> this.__send "PUT", action, data, callback
  delete: (action, data, callback) -> this.__send "DELETE", action, data, callback

  __send: (method, action, data, callback) ->
    jqxhr = $.ajax({
      method: method,
      url: "#{this.__getResourceUrl()}/#{action}",
      data: data
    })
    jqxhr.always ->
    jqxhr.fail ->
    jqxhr.done (data) => callback data

  __assignAttributes: (data) ->
    for key, val of data
      attrName = this.__fetchAttrName key
      attrType = this.__fetchAttrType attrName
      if not val?
        @[attrName] = null
        continue
      switch attrType
        when "Date" then val = new Date Date.parse val
        when "Int" then val = parseInt val
      @[attrName] = val

  __fetchAttrName: (remoteName) ->
    mappedName = this.constructor.attrMapping? and this.constructor.attrMapping[remoteName]
    mappedName = null if mappedName is false
    return mappedName if mappedName? && not this.constructor.attributes?
    return remoteName if this.constructor.attributes[remoteName]?
    for name, config of this.constructor.attributes
      if config.remoteName is remoteName
        if mappedName?
          throw new Error "App.Models.#{this.getIdentity()}: double name declaration for remote: #{remoteName}."
        return name
    remoteName

  __fetchAttrType: (attrName) ->
    attrType = this.constructor.attrTypes? and this.constructor.attrTypes[attrName]
    attrType = null if attrType is false
    return attrType if not this.constructor.attributes?
    return attrType if not this.constructor.attributes[attrName]?
    anotherAttrType = this.constructor.attributes[attrName].type
    if anotherAttrType? and attrType
      throw new Error "App.Models.#{this.getIdentity()}: double type declaration for attribute: #{attrName}."
    else if anotherAttrType? then anotherAttrType
    else attrType

  __initAttributes: ->
    for name, config of this.constructor.attributes
      this[name] = null

  __assignRemoteErrorMessages: (remoteErrors) ->
    for remoteName, errors of remoteErrors
      attr = this.__fetchAttrName remoteName
      for error in errors
        this.addErrorMessage error, for: attr

  __getResourceUrl: ->
    if @id?
      "#{this.constructor.__getResourcesUrl()}/#{@id}"
    else
      this.constructor.__getResourcesUrl()