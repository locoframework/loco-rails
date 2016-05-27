class App.Mixins.Disconnection
  disconnectedForTooLong: (time) ->
    msg = "You have been disconnected from the server for too long. Reload page!"
    view = new App.Views.Shared.Flash alert: msg, hide: false
    view.render()
