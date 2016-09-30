class App.Services.NotificationCenter
  receivedSignal: (data) ->
    switch data.action
      when 'ping'
        return if App.Env.namespaceController.constructor isnt App.Controllers.User
        alert 'Ping!'