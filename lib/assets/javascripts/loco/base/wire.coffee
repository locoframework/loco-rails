class App.Wire
  constructor: (opts = {}) ->
    @syncTime = null
    @token = null
    @pollingInterval = null
    @pollingTime = opts.pollingTime
    @log = opts.log
    @ssl = opts.ssl

  setToken: (token) -> @token = token

  getSyncTime: -> @syncTime
  resetSyncTime: -> @syncTime = null

  getPollingTime: -> @pollingTime
  setPollingTime: (val) ->
    @pollingTime = val
    this.disableNotifications()
    this.connect()

  getPollingInterval: -> @pollingInterval

  getSSL: -> @ssl
  setSSL: (val) -> @ssl = val

  connect: ->
    @pollingInterval = setInterval =>
      this._check()
    , @pollingTime

  disableNotifications: -> window.clearInterval @pollingInterval

  _check: ->
    return if Object.keys(App.IdentityMap.imap).length is 0 and not @token? and @syncTime?
    jqxhr = $.ajax method: "GET", url: this._getURL(), data: this._requestParams()
    jqxhr.always ->
    jqxhr.fail ->
    jqxhr.done (data) =>
      @syncTime = data[1]
      notifications = data[0]
      return if notifications.length is 0
      this._processNotification notification for notification in notifications
      this._check() if notifications.length is 100

  _processNotification: (notification) ->
    console.log notification if @log
    [className, id, signal, payload] = notification
    model = App.Env.loco.getModelForRemoteName className
    identity = model.getIdentity()
    return if not App.IdentityMap.imap[identity]?
    if App.IdentityMap.imap[identity][id]?
      obj = App.IdentityMap.find identity, id
      if obj["receivedSignal"]?
        obj.receivedSignal signal, payload
      this._emitSignalToMembers id, signal, payload, model, identity
    if model["receivedSignal"]?
      model.receivedSignal signal, payload
    return if not App.IdentityMap.imap[identity]["collection"]?
    return if App.IdentityMap.imap[identity]["collection"].length is 0
    this._emitSignalToCollection signal, payload, identity

  _emitSignalToMembers: (id, signal, payload, model, identity, obj = null) ->
    if not obj?
      obj = new model id: id
    for connObj in App.IdentityMap.findConnected identity, id
      if connObj.receiverFor(obj)?
        connObj[connObj.receiverFor(obj)] signal, payload
      else if connObj["receivedSignal"]?
        connObj.receivedSignal signal, payload

  _emitSignalToCollection: (signal, payload, identity) ->
    for obj in App.IdentityMap.imap[identity]["collection"]
      if obj.receiverFor(identity)?
        obj[obj.receiverFor(identity)] "#{identity} #{signal}", payload
      else if obj["receivedSignal"]?
        obj.receivedSignal "#{identity} #{signal}", payload

  _requestParams: ->
    params = {synced_at: @syncTime}
    if @token? then params["token"] = @token
    params

  _getURL: ->
    [protocol, _, host] = window.location.href.split '/'
    if @ssl?
      protocol = if @ssl then 'https:' else "http:"
    "#{protocol}//#{host}/notification-center"