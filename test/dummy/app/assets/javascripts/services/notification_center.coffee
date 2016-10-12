class App.Services.NotificationCenter
  receivedSignal: (data) ->
    switch data.signal
      when 'ping'
        return if App.Env.namespaceController.constructor isnt App.Controllers.User
        alert 'Ping!'
      when 'message'
        return if App.Env.namespaceController.constructor isnt App.Controllers.User
        return if App.Env.controller.constructor isnt App.Controllers.User.Rooms
        return if App.Env.action isnt 'show'
        App.Env.controller.getView('show').receivedMessage data.message, data.author