import { Env } from "loco-js";

import UserController from "controllers/User";
import RoomsController from "controllers/user/rooms.coffee";

class NotificationCenter
  receivedSignal: (data) ->
    switch data.signal
      when 'ping'
        this._pingSignal()
      when 'message'
        this._messageSignal data

  _pingSignal: ->
    return if Env.namespaceController.constructor isnt UserController
    alert 'Ping!'

  _messageSignal: (data) ->
    return if not view = this._getRoomView()
    view.receivedMessage data.message, data.author

  _getRoomView: ->
    return false if Env.namespaceController.constructor isnt UserController
    return false if Env.controller.constructor isnt RoomsController
    return false if Env.action isnt 'show'
    Env.controller.getView 'show'

export default NotificationCenter