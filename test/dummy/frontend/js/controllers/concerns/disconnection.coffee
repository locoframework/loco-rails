import Flash from "views/shared/flash.coffee"

class Disconnection
  disconnectedForTooLong: (time) ->
    msg = "You have been disconnected from the server for too long. Reload page!"
    view = new Flash alert: msg, hide: false
    view.render()

export default Disconnection