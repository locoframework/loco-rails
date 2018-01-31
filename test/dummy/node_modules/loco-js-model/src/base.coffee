import Validators from './validators'
import Config from './config'
import Utils from './utils'
import IdentityMap from './identity_map.coffee'
import Models from './models'
import { filterParams, sendReq } from './helpers/connectivity';

class Base
  @getIdentity: -> if @identity? then @identity else throw("Specify Model's @identity!")

  @getRemoteName: -> if @remoteName? then @remoteName else @getIdentity()

  @all: (opts = {}) -> @get "all", opts
  @get: (action, opts = {}) -> @__send "GET", action, opts
  @post: (action, opts = {}) -> @__send "POST", action, opts
  @put: (action, opts = {}) -> @__send "PUT", action, opts
  @patch: (action, opts = {}) -> @__send "PATCH", action, opts
  @delete: (action, opts = {}) -> @__send "DELETE", action, opts

  @find: (idOrObj) ->
    urlParams = {}
    if typeof idOrObj is "object"
      urlParams = idOrObj
      id = idOrObj.id
      delete urlParams.id
    else
      id = idOrObj
    req = sendReq 'GET', "#{@__getResourcesUrl(urlParams)}/#{id}", urlParams
    return new Promise (resolve, reject) =>
      req.onerror = (e) -> reject e
      req.onload = (e) =>
        record = JSON.parse e.target.response
        resolve @__initFromJSON(record, idOrObj.resource)

  @getAttribRemoteName: (attrib) ->
    return null if not this.attributes?
    return null if not this.attributes[attrib]?
    return attrib if not this.attributes[attrib].remoteName?
    this.attributes[attrib].remoteName

  @getResourcesUrlParams: (opts) ->
    url = @__getResourcesUrl(resource: opts.resource)
    regexp = /:(\w+)\/?/
    params = []
    while match = regexp.exec url
      params.push match[1]
      url = url.replace match[0], match[1]
    params

  @__getResourcesUrl: (opts) ->
    resourcesUrl = if not @resources?
      "/#{@getRemoteName().toLowerCase()}s"
    else if opts.resource
      @resources[opts.resource].url
    else if Config.scope? and @resources[Config.scope]?
      @resources[Config.scope].url
    else
      @resources.url
    if Config.protocolWithHost?
      resourcesUrl = "#{Config.protocolWithHost}#{resourcesUrl}"
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
    if parts.length is 1
      model = Models[parts[0]]
      if not model?
        return new this params
      return new model params
    model = Models[parts[0]][parts[1]]
    new model params

  @__page: (i, pageData, resp) ->
    url = pageData.url
    pageData.params[pageData.pageParam] = i
    if pageData.method is 'GET'
      url = url + '?' + Utils.Obj.toURIParams(pageData.params)
    req = sendReq pageData.method, url, pageData.params
    return new Promise (resolve, reject) =>
      req.onerror = (e) -> reject e
      req.onload = (e) =>
        data = JSON.parse e.target.response
        if data.constructor is Array
          for record in data
            obj = @__initFromJSON record, pageData.resource
            resp.push obj
        else if data.resources?
          if resp.constructor is Array
            resp = {resources: [], count: 0}
          for record in data.resources
            obj = @__initFromJSON record, pageData.resource
            resp.resources.push obj
          resp.count = data.count
        else
          for key, val of data
            resp[key] = val
        resolve resp

  @__paginate: (opts) ->
    pageData = {
      method: opts.method,
      url: opts.url,
      params: opts.params,
      pageParam: opts.pageParam,
      resource: opts.resource
    }
    @__page(opts.pageNum || 1, pageData, []).then (data) =>
      total = data.count || opts.total
      promise = Promise.resolve data
      return promise if opts.pageNum?
      return promise if total <= opts.perPage
      max = parseInt total / opts.perPage
      max += 1 if max isnt total / opts.perPage
      return promise if max is 1
      for i in [2..max]
        func = (i) =>
          promise = promise.then (_) =>
            return @__page i, pageData, data
        func i
      return promise

  @__getPaginationParam: (resource) ->
    defaultParam = 'page'
    if resource? and @resources? and @resources[resource]
      return @resources[resource].paginate?.param || defaultParam
    if Config.scope? and @resources? and @resources[Config.scope]?
      param = @resources[Config.scope]?.paginate?.param
      return param || defaultParam
    if @resources?.paginate?.param?
      return @resources.paginate.param
    defaultParam

  @__getPaginationPer: (resource) ->
    if resource? and @resources? and @resources[resource]
      return @resources[resource].paginate?.per
    if Config.scope? and @resources? and @resources[Config.scope]?
      return @resources[Config.scope]?.paginate?.per
    if @resources?.paginate?.per?
      return @resources.paginate.per
    null

  @__send: (method, action, opts) ->
    url = @__getResourcesUrl opts
    if action isnt "all"
      url = "#{url}/#{action}"
    data = {
      method: method,
      url: url,
      params: filterParams(opts),
      resource: opts.resource,
      perPage: @__getPaginationPer(opts.resource),
      pageNum: opts.page,
      pageParam: @__getPaginationParam(opts.resource),
      total: opts.total || opts.count
    }
    @__paginate data

  @__initFromJSON: (record, resource) ->
    obj = @__initSubclass record
    obj.resource = resource
    IdentityMap.add obj
    obj

  constructor: (data = {}) ->
    @id = null
    @errors = null
    @resource = data.resource
    this.__initAttributes() if this.constructor.attributes?
    this.__assignAttributes(data) if data?

  setResource: (name) -> @resource = name

  getIdentity: -> this.constructor.getIdentity()

  getAttrRemoteName: (attr) ->
    return null if not this.constructor.attributes?
    return null if not this.constructor.attributes[attr]?
    this.constructor.attributes[attr].remoteName or attr

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

  assignAttr: (attrName, val) ->
    attrType = this.getAttrType attrName
    if not val?
      @[attrName] = null
      return
    switch attrType
      when "Date" then val = new Date Date.parse val
      when "Integer", "Int" then val = parseInt val
      when "Float" then val = parseFloat val
      when "Boolean", "Bool"
        val = if typeof val is 'boolean'
          val
        else
          Boolean parseInt val
      when "Number" then val = Number val
      when "String" then val = String val
    @[attrName] = val

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
        continue if validationSettings.if? and !validationSettings.if(this)
        validator = validationName.charAt(0).toUpperCase() + validationName.slice(1)
        if not Validators[validator]?
          console.warn "\"#{validator}\" validator is not implemented!"
          continue
        pvs = this.__processedValidationSettings validationSettings
        Validators[validator].instance(this, name, pvs).validate()
    if this.constructor.validate?
      this[meth]() for meth in this.constructor.validate
    !this.errors?

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
    httpMeth = if @id? then "PUT" else "POST"
    req = sendReq httpMeth, this.__getResourceUrl(), this.serialize()
    return new Promise (resolve, reject) =>
      req.onerror = (e) -> reject e
      req.onload = (e) =>
        data = JSON.parse e.target.response
        if data.success
          resolve data
          return
        this.__assignRemoteErrorMessages(data.errors) if data.errors?
        resolve data

  updateAttribute: (attr) ->
    req = sendReq 'PUT', this.__getResourceUrl(), this.serialize(attr)
    return new Promise (resolve, reject) =>
      req.onerror = (e) -> reject e
      req.onload = (e) =>
        if e.target.status >= 200 and e.target.status < 400
          data = JSON.parse e.target.response
          if data.success
            resolve data
            return
          this.__assignRemoteErrorMessages(data.errors) if data.errors?
          resolve data
        else if e.target.status >= 500
          reject e

  serialize: (attr = null) ->
    return {} if not this.constructor.attributes?
    hash = {}
    mainKey = this.constructor.getRemoteName().toLowerCase()
    hash[mainKey] = {}
    attribs = {}
    if attr?
      attribs[attr] = null
    else
      attribs = this.constructor.attributes
    for attr, _ of attribs
      remoteName = this.getAttrRemoteName attr
      hash[mainKey][remoteName] = this[attr]
    hash

  reload: ->
    findParams = {id: this.id, resource: this.resource}
    for param in this.constructor.getResourcesUrlParams(resource: this.resource)
      findParams[param] = this[param]
    this.constructor.find findParams

  changes: ->
    result = {}
    currentObj = IdentityMap.find this.getIdentity(), this.id
    for name, val of this.attributes()
      if val isnt currentObj[name]
        continue if val? and val.constructor is Date and currentObj[name] - val is 0
        result[name] = {is: currentObj[name], was: val} if val isnt currentObj[name]
    return result

  applyChanges: -> this[name] = vals.is for name, vals of this.changes()

  toKey: -> "#{this.getIdentity().toLowerCase()}_#{this.id}"

  get: (action, data = {}) -> this.__send "GET", action, data
  post: (action, data = {}) -> this.__send "POST", action, data
  put: (action, data = {}) -> this.__send "PUT", action, data
  patch: (action, data = {}) -> this.__send "PATCH", action, data
  delete: (action, data = {}) -> this.__send "DELETE", action, data

  __send: (method, action, data) ->
    url = this.__getResourceUrl()
    if action?
      url = "#{url}/#{action}"
    req = sendReq method, url, data
    return new Promise (resolve, reject) ->
      req.onerror = (e) -> reject e
      req.onload = (e) ->
        if e.target.status >= 200 and e.target.status < 400
          data = JSON.parse e.target.response
          resolve data
        else if e.target.status >= 500
          reject e

  __assignAttributes: (data) ->
    for key, val of data
      attrName = this.getAttrName key
      this.assignAttr attrName, val

  __initAttributes: ->
    for name, config of this.constructor.attributes
      this[name] = null

  __assignRemoteErrorMessages: (remoteErrors) ->
    for remoteName, errors of remoteErrors
      attr = this.getAttrName remoteName
      for error in errors
        this.addErrorMessage error, for: attr

  __getResourceUrl: ->
    url = this.constructor.__getResourcesUrl resource: this.resource, obj: this
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

export default Base