class App.Views.User.Rooms.List extends App.Views.Base
  constructor: (opts = {}) ->
    super opts

  render: ->
    this.connectWith App.Models.Room

  receivedSignal: (signal, data) ->
    switch signal
      when "Room member_joined"
        this._memberJoined data.room_id
      when "Room member_left"
        this._memberLeft data.room_id
      when "Room created"
        renderedRoom = JST["templates/user/rooms/room_for_list"] room: data.room
        document.getElementById('rooms_list').insertAdjacentHTML('beforeend', renderedRoom)
      when "Room destroyed"
        roomNode = document.getElementById("room_#{data.room_id}")
        roomNode.parentNode.removeChild(roomNode)

  _memberJoined: (roomId) ->
    node = this._membersNode roomId
    node.textContent = parseInt(node.text()) + 1

  _memberLeft: (roomId) ->
    node = this._membersNode roomId
    node.textContent = parseInt(node.text()) - 1

  _membersNode: (roomId) ->
    document.querySelector("#room_#{roomId} td.members")