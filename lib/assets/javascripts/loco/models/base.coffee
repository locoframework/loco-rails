class App.Models.Base
  # Ex.
  # class App.Models.Post extends App.Models.Base
  #   @identity = "Post"  # required
  #
  #   @resources =
  #     url: "/posts"  # optional
  #     paginate: {per: 100, param: "page"}  # param is optional
  #
  #   @attributes =
  #     validatedAt:
  #       type: "Date"
  #       remoteName: "updated_at"
  #       validations:
  #         presence: true

  constructor: (data = {}) ->
    @id = null
    @errors = null
    @resource = data.resource
    this.__initAttributes() if this.constructor.attributes?
    this.__assignAttributes(data) if data?

  @all: (opts = {}) -> @get "all", opts

  @find: (idOrObj) ->
    urlParams = {}
    if typeof idOrObj is "object"
      urlParams = idOrObj
      id = idOrObj.id
      delete urlParams.id
    else
      id = idOrObj
    jqxhr = $.ajax({
      dataType: 'json',
      method: 'GET',
      url: "#{@__getResourcesUrl(urlParams)}/#{id}",
      data: urlParams
    })
    return new Promise (resolve, reject) =>
      jqxhr.fail (xhr) -> reject xhr
      jqxhr.done (record) =>
        obj = @__initSubclass record
        App.IdentityMap.add obj
        resolve obj

  @get: (action, opts = {}) -> @__send "GET", action, opts
  @post: (action, opts = {}) -> @__send "POST", action, opts
  @put: (action, opts = {}) -> @__send "PUT", action, opts
  @delete: (action, opts = {}) -> @__send "DELETE", action, opts

  @getIdentity: -> if @identity? then @identity else throw("Specify Model's @identity!")

  @getRemoteName: -> if @remoteName? then @remoteName else @getIdentity()

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
    resourcesUrl = if not @resources?
      "/#{@getIdentity().toLowerCase()}s"
    else if opts.resource
      @resources[opts.resource].url
    else if App.Env.scope? and @resources[App.Env.scope]?
      @resources[App.Env.scope].url
    else
      @resources.url
    match = /:(\w+)\/?/.exec resourcesUrl
    return resourcesUrl if not match?
    if opts[match[1]]?
      resourcesUrl = resourcesUrl.replace ":#{match[1]}", opts[match[1]]
      delete opts[match[1]]
    else if opts.obj? and opts.obj[match[1]]?
      resourcesUrl = resourcesUrl.replace ":#{match[1]}", opts.obj[match[1]]
    return resourcesUrl

  @__initSubclass: (params = {}) ->
    parts = @getIdentity().split "."
    return new App.Models[parts[0]] params if parts.length is 1
    new App.Models[parts[0]][parts[1]] params

  @__page: (i, opts = {}, reqOpts = {}, resp = {resources: [], count: 0}) ->
    httpMethod = reqOpts.method || "GET"
    url = reqOpts.url || @__getResourcesUrl(opts)
    data = {}
    if reqOpts.data?
      for key, val of reqOpts.data
        continue if key is "resource"
        data[key] = val
    data[@__getPaginationParam()] = i
    jqxhr = $.ajax
      dataType: "json",
      method: httpMethod,
      url: url,
      data: data
    return new Promise (resolve, reject) =>
      jqxhr.fail (xhr) -> reject xhr
      jqxhr.done (data) =>
        resp.count = data.count
        for key, val of data
          resp[key] = val if ['resources', 'count'].indexOf(key) is -1
        for record in data.resources
          obj = @__initSubclass record
          obj.resource = opts.resource if opts.resource?
          App.IdentityMap.add obj
          resp.resources.push obj
        resolve resp

  @__paginate: (opts, reqOpts) ->
    perPage = @__getPaginationPer()
    pageNum = opts.page ? 1
    @__page(pageNum, opts, reqOpts).then (data) =>
      return Promise.resolve(data) if opts.page?
      return Promise.resolve(data) if data.count <= perPage
      max = parseInt data.count / perPage
      max += 1 if max isnt data.count / perPage
      promise = Promise.resolve(data)
      return promise if max is 1
      for i in [2..max]
        func = (i) =>
          promise = promise.then (arr) =>
            return @__page i, opts, reqOpts, data
        func i
      return promise

  @__getPaginationParam: ->
    if @resources?.paginate?.page?
      return @resources.paginate.page
    if App.Env.scope? and @resources? and @resources[App.Env.scope]?
      param = @resources[App.Env.scope]?.paginate?.param
      return param if param?
    if @paginate? and @paginate.param? then @paginate.param else "page"

  # TODO: test it!
  @__getPaginationPer: ->
    if App.Env.scope? and @resources? and @resources[App.Env.scope]?
      per = @resources[App.Env.scope]?.paginate?.per
      return per if per?
    if @resources?.paginate?.per?
      return @resources.paginate.per
    if @paginate? and @paginate.per? then @paginate.per else null

  @__send: (method, action, opts) ->
    url = @__getResourcesUrl opts
    if action isnt "all"
      url = "#{url}/#{action}"
    reqOpts = {method: method, url: url, data: opts}
    @__paginate opts, reqOpts

  setResource: (name) -> @resource = name

  getIdentity: ->
    val = this.constructor.identity
    return val if val?
    this.constructor.name

  # deprecated: use getAttrRemoteName()
  getRemoteName: (attr) ->
    return null if not this.constructor.attributes?
    return null if not this.constructor.attributes[attr]?
    this.constructor.attributes[attr].remoteName or attr

  getAttrRemoteName: (attr) -> this.getRemoteName attr

  getAttrName: (remoteName) ->
    return remoteName if not this.constructor.attributes?
    return remoteName if this.constructor.attributes[remoteName]?
    for name, config of this.constructor.attributes
      if config.remoteName is remoteName
        return name
    remoteName

  getAttrType: (attrName) ->
    return null if not this.constructor.attributes?
    return null if not this.constructor.attributes[attrName]?
    this.constructor.attributes[attrName].type

  attributes: ->
    attribs = {id: this.id}
    return attribs if not this.constructor.attributes?
    for name, _ of this.constructor.attributes
      attribs[name] = this[name]
    attribs

  isValid: ->
    return true if not this.constructor.attributes?
    @errors = null
    for name, config of this.constructor.attributes
      continue if not config.validations?
      for validationName, validationSettings of config.validations
        continue if this.id? and validationSettings.on is "create"
        continue if !this.id? and validationSettings.on is "update"
        validator = validationName.charAt(0).toUpperCase() + validationName.slice(1)
        if not App.Validators[validator]?
          console.log "Warning! \"#{validator}\" validator is not implemented!"
          continue
        pvs = this.__processedValidationSettings validationSettings
        App.Validators[validator].instance(this, name, pvs).validate()
    if this.constructor.validate?
      this[meth]() for meth in this.constructor.validate
    if this.errors? then false else true

  isInvalid: -> !this.isValid()

  isEmpty: ->
    for name, val of this.attributes()
      return false if this[name] isnt null
    true

  addErrorMessage: (message, opts = {}) ->
    @errors = {} if not @errors?
    @errors[opts.for] = [] if not @errors[opts.for]?
    @errors[opts.for].push message

  save: ->
    return false if not this.isValid()
    jqxhr = $.ajax
      dataType: 'json',
      method: if @id? then "PUT" else "POST",
      url: this.__getResourceUrl(),
      data: this.serialize()
    return new Promise (resolve, reject) =>
      jqxhr.fail (xhr) -> reject xhr
      jqxhr.done (data) =>
        if data.success
          resolve data
          return true
        this.__assignRemoteErrorMessages(data.errors) if data.errors?
        resolve data
        return false

  serialize: ->
    return {} if not this.constructor.attributes?
    hash = {}
    mainKey = this.constructor.getRemoteName().toLowerCase()
    hash[mainKey] = {}
    for attr, _ of this.constructor.attributes
      remoteName = this.getRemoteName attr
      hash[mainKey][remoteName] = this[attr]
    hash

  reload: ->
    findParams = {id: this.id}
    for param in this.constructor.getResourcesUrlParams()
      findParams[param] = this[param]
    this.constructor.find findParams

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

  get: (action, data = {}) -> this.__send "GET", action, data
  post: (action, data = {}) -> this.__send "POST", action, data
  put: (action, data = {}) -> this.__send "PUT", action, data
  delete: (action, data = {}) -> this.__send "DELETE", action, data

  __send: (method, action, data) ->
    url = this.__getResourceUrl()
    if action?
      url = "#{url}/#{action}"
    jqxhr = $.ajax
      dataType: 'json',
      method: method,
      url: url,
      data: data
    return new Promise (resolve, reject) ->
      jqxhr.fail (xhr) -> reject xhr
      jqxhr.done (data) -> resolve data

  __assignAttributes: (data) ->
    for key, val of data
      attrName = this.getAttrName key
      attrType = this.getAttrType attrName
      if not val?
        @[attrName] = null
        continue
      switch attrType
        when "Date" then val = new Date Date.parse val
        when "Int" then val = parseInt val
      @[attrName] = val

  __initAttributes: ->
    for name, config of this.constructor.attributes
      this[name] = null

  __assignRemoteErrorMessages: (remoteErrors) ->
    for remoteName, errors of remoteErrors
      attr = this.getAttrName remoteName
      for error in errors
        this.addErrorMessage error, for: attr

  __getResourceUrl: ->
    url = this.constructor.__getResourcesUrl resource: @resource, obj: this
    return url if not @id?
    "#{url}/#{@id}"

  __processedValidationSettings: (validationSettings) ->
    res = {}
    for confName, confVal of validationSettings
      if typeof confVal is 'function'
        res[confName] = confVal this
      else
        res[confName] = confVal
    res