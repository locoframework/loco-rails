class App.Views.User.Rooms.Show extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @roomId = opts.id

  render: ->
    this.connectWith App.Models.Room
    this._handleSendingMessage()

  renderMembers: (members) ->
    for member in members
      this._memberJoined member

  receivedMessage: (message, author) ->
    $('#messages').append "<p><b>#{author}</b>: #{message}</p>"

  receivedSignal: (signal, data) ->
    switch signal
      when "Room member_joined"
        return if data.room_id isnt @roomId
        this._memberJoined data.member
      when "Room member_left"
        return if data.room_id isnt @roomId
        this._memberLeft data.member

  _handleSendingMessage: ->
    $(document).on 'keypress', '[data-behavior~=room-speaker]', (event) =>
      return if event.keyCode isnt 13
      event.preventDefault()
      App.Env.loco.emit signal: 'message', txt: event.target.value, room_id: @roomId
      event.target.value = ''

  _memberJoined: (member) ->
    $('#members').append "<li id='user_#{member.id}'>#{member.username}</li>"

  _memberLeft: (member) ->
    $('#members').find("li#user_#{member.id}").remove()
