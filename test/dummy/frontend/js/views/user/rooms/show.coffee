import { Env, Views } from "loco-js";

import Room from "models/User";

class Show extends Views.Base
  constructor: (opts = {}) ->
    super opts
    @roomId = opts.id

  render: ->
    this.connectWith(Room);
    this._handleSendingMessage()

  renderMembers: (members) ->
    for member in members
      this._memberJoined member

  receivedMessage: (message, author) ->
    renderedMessage = "<p><b>#{author}</b>: #{message}</p>"
    document.getElementById('messages').insertAdjacentHTML('beforeend', renderedMessage)

  receivedSignal: (signal, data) ->
    switch signal
      when "Room member_joined"
        return if data.room_id isnt @roomId
        this._memberJoined data.member
      when "Room member_left"
        return if data.room_id isnt @roomId
        this._memberLeft data.member

  _handleSendingMessage: ->
    document.querySelector('[data-behavior~=room-speaker]').addEventListener 'keypress', (event) =>
      return if event.keyCode isnt 13
      event.preventDefault()
      Env.loco.emit(signal: 'message', txt: event.target.value, room_id: @roomId);
      event.target.value = ''

  _memberJoined: (member) ->
    li = "<li id='user_#{member.id}'>#{member.username}</li>"
    document.getElementById('members').insertAdjacentHTML('beforeend', li)

  _memberLeft: (member) ->
    node = document.querySelector("#members li#user_#{member.id}")
    node.parentNode.removeChild(node)

export default Show;
