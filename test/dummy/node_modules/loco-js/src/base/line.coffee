import Channels from '../channels'
import Env from '../env'
import {Deps} from '../deps'

class Line
  constructor: (opts = {}) ->
    @connected = false

  connect: ->
    Channels.Loco.NotificationCenter = (Deps.cable || App.cable).subscriptions.create
      channel: "Loco::NotificationCenterChannel"
    ,
      connected: =>
        console.log 'ws connected'
        @connected = true
        wire = Env.loco.getWire()
        if wire?
          wire.setDelayedDisconnection()
        this._sendNotification loco: 'connected'
      disconnected: =>
        console.log 'ws disconnected'
        @connected = false
        wire = Env.loco.getWire()
        if wire?
          wire.setUuid null
          wire.fetchSyncTime after: 'connect'
        this._sendNotification loco: 'disconnected'
      rejected: =>
        console.log 'ws rejected'
        this._sendNotification loco: 'rejected'
      received: (data) =>
        if data.loco?
          this._processSystemNotification data.loco
          delete data.loco
        return if Object.keys(data).length is 0
        this._sendNotification data

  isWireAllowed: -> not @connected

  send: (data) -> Channels.Loco.NotificationCenter.send data

  _processSystemNotification: (data) ->
    if data.connection_check?
      this.send loco: {connection_check: true}
    wire = Env.loco.getWire()
    return if not wire?
    if data.sync_time?
      wire.setSyncTime data.sync_time
    if data.uuid?
      console.log "uuid: #{data.uuid}"
      wire.setUuid data.uuid
    if data.notification?
      wire.processNotification data.notification
    if data.xhr_notifications?
      wire.check()
    if data.start_ajax_polling
      console.log "wire connected"
      @connected = null
      wire.setUuid null
      wire.fetchSyncTime after: 'connect'

  _sendNotification: (data) ->
    notificationCenter = if Deps.NotificationCenter?
      new Deps.NotificationCenter
    else
      new App.Services.NotificationCenter
    notificationCenter.receivedSignal data

export default Line