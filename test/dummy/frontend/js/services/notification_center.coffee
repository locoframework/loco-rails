import { Env } from "loco-js"

class NotificationCenter
  receivedSignal: (data) ->
    switch data.signal
      when 'ping'
        this._pingSignal()
      when 'message'
        this._messageSignal data

  _pingSignal: ->
    return if Env.namespaceController.constructor isnt App.Controllers.User
    alert 'Ping!'

  _messageSignal: (data) ->
    return if not view = this._getRoomView()
    view.receivedMessage data.message, data.author

  _getRoomView: ->
    return false if Env.namespaceController.constructor isnt App.Controllers.User
    return false if Env.controller.constructor isnt App.Controllers.User.Rooms
    return false if Env.action isnt 'show'
    Env.controller.getView 'show'

export default NotificationCenter