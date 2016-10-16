class App.Services.NotificationCenter
  receivedSignal: (data) ->
    switch data.signal
      when 'ping'
        this._pingSignal()
      when 'message'
        this._messageSignal data

  _pingSignal: ->
    return if App.Env.namespaceController.constructor isnt App.Controllers.User
    alert 'Ping!'

  _messageSignal: (data) ->
    return if not view = this._getRoomView()
    view.receivedMessage data.message, data.author

  _getRoomView: ->
    return false if App.Env.namespaceController.constructor isnt App.Controllers.User
    return false if App.Env.controller.constructor isnt App.Controllers.User.Rooms
    return false if App.Env.action isnt 'show'
    App.Env.controller.getView 'show'