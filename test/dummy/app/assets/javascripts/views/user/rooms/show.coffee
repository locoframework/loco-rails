class App.Views.User.Rooms.Show extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @roomId = opts.id

  render: ->
    this._handleSendingMessage()

  _handleSendingMessage: ->
    $(document).on 'keypress', '[data-behavior~=room-speaker]', (event) =>
      return if event.keyCode isnt 13
      event.preventDefault()
      App.Env.loco.emit signal: 'message', txt: event.target.value, room_id: @roomId
      event.target.value = ''

  receivedMessage: (message, author) ->
    $('#messages').append "<p><b>#{author}</b>: #{message}</p>"
