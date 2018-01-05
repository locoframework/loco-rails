import Env from '../env'
import {IdentityMap} from '../deps'
import ObjectUtils from '../utils/object.coffee'

class Wire
  constructor: (opts = {}) ->
    @syncTime = null
    @token = null
    @pollingInterval = null
    @pollingTime = opts.pollingTime ? 3000
    @log = if opts.log? and opts.log then true else false
    @ssl = opts.ssl
    @location = opts.location ? 'notification-center'
    @size = opts.size ? 100
    @protocolWithHost = opts.protocolWithHost
    @allowedDisconnectionTime = opts.allowedDisconnectionTime ? 10
    @disconnectedSinceTime = null
    @uuid = null
    @delayedDisconnection = false

  setToken: (token) -> @token = token

  getSyncTime: -> @syncTime
  setSyncTime: (val) -> @syncTime = val
  resetSyncTime: -> @syncTime = null

  getPollingTime: -> @pollingTime
  setPollingTime: (val) ->
    @pollingTime = val
    this.disconnect()
    this.connect()

  getPollingInterval: -> @pollingInterval

  getSSL: -> @ssl
  setSSL: (val) -> @ssl = val

  getLocation: -> @location
  setLocation: (val) -> @location = val

  getSize: -> @size
  setSize: (val) -> @size = val

  getAllowedDisconnectionTime: -> @allowedDisconnectionTime
  setAllowedDisconnectionTime: (val) -> @allowedDisconnectionTime = val

  getUuid: -> @uuid
  setUuid: (val) -> @uuid = val

  setDelayedDisconnection: -> @delayedDisconnection = true

  connect: ->
    line = Env.loco.getLine()
    if line? and !line.isWireAllowed()
      return
    @pollingInterval = setInterval =>
      this.check()
      if @delayedDisconnection
        @delayedDisconnection = false
        this.disconnect()
    , @pollingTime

  disconnect: -> window.clearInterval @pollingInterval

  disableNotifications: ->
    console.log 'Wire#disableNotifications - DEPRECATED'
    this.disconnect()

  processNotification: (notification) ->
    console.log notification if @log
    [className, id, signal, payload] = notification
    model = Env.loco.getModelForRemoteName className
    identity = model.getIdentity()
    return if not IdentityMap.imap[identity]?
    if IdentityMap.imap[identity][id]?
      obj = IdentityMap.find identity, id
      if obj["receivedSignal"]?
        obj.receivedSignal signal, payload
      this._emitSignalToMembers id, signal, payload, model, identity
    if model["receivedSignal"]?
      model.receivedSignal signal, payload
    return if not IdentityMap.imap[identity]["collection"]?
    return if IdentityMap.imap[identity]["collection"].length is 0
    this._emitSignalToCollection signal, payload, identity

  processSignal: (notification) -> this.processNotification notification

  check: ->
    return if Object.keys(IdentityMap.imap).length is 0 and not @token? and @syncTime?
    request = new XMLHttpRequest()
    request.open 'GET', this._getURL() + '?' + ObjectUtils.toURIParams(this._requestParams())
    request.onload = (e) =>
      if e.target.status >= 200 and e.target.status < 400
        data = JSON.parse e.target.response
        @disconnectedSinceTime = null
        @syncTime = data[1]
        notifications = data[0]
        return if notifications.length is 0
        this.processNotification notification for notification in notifications
        this.check() if notifications.length is @size
      else if e.target.status >= 500
        this._handleDisconnection()
    request.onerror = =>
      this._handleDisconnection()
    request.send()

  fetchSyncTime: (opts = {}) ->
    request = new XMLHttpRequest()
    request.open 'GET', "#{this._getURL()}/sync-time"
    request.onerror = =>
      this[opts.after]() if opts.after?
    request.onload = (e) =>
      if e.target.status >= 200 and e.target.status < 400
        data = JSON.parse e.target.response
        @syncTime = data.sync_time
        this[opts.after]() if opts.after?
      else if e.target.status >= 500
        this[opts.after]() if opts.after?
    request.send()

  _emitSignalToMembers: (id, signal, payload, model, identity, obj = null) ->
    if not obj?
      obj = new model id: id
    for connObj in IdentityMap.findConnected identity, id
      if connObj.receiverFor(obj)?
        connObj[connObj.receiverFor(obj)] signal, payload
      else if connObj["receivedSignal"]?
        connObj.receivedSignal signal, payload

  _emitSignalToCollection: (signal, payload, identity) ->
    for obj in IdentityMap.imap[identity]["collection"]
      if obj.receiverFor(identity)?
        obj[obj.receiverFor(identity)] "#{identity} #{signal}", payload
      else if obj["receivedSignal"]?
        obj.receivedSignal "#{identity} #{signal}", payload

  _requestParams: ->
    params = {synced_at: @syncTime}
    if @token? then params.token = @token
    if @uuid? then params.uuid = @uuid
    params

  _getURL: ->
    [protocol, _, host] = window.location.href.split '/'
    if @protocolWithHost?
      [protocol, host] = @protocolWithHost.split '//'
    if @ssl?
      protocol = if @ssl then 'https:' else "http:"
    "#{protocol}//#{host}/#{@location}"

  _handleDisconnection: ->
    if not @disconnectedSinceTime?
      @disconnectedSinceTime = new Date()
    diffInSec = (new Date() - @disconnectedSinceTime) / 1000
    ctrl = Env.namespaceController ? Env.controller
    if diffInSec > @allowedDisconnectionTime and ctrl['disconnectedForTooLong']?
      ctrl.disconnectedForTooLong @disconnectedSinceTime

export default Wire