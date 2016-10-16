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

  _memberJoined: (roomId) ->
    node = this._membersNode roomId
    node.text parseInt(node.text()) + 1

  _memberLeft: (roomId) ->
    node = this._membersNode roomId
    node.text parseInt(node.text()) - 1

  _membersNode: (roomId) -> $("#room_#{roomId}").find 'td.members'