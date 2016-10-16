class App.Models.Room.Member extends App.Models.Base
  @identity = "Room.Member"
  @resources =
    url: '/user/rooms/:roomId/members', paginate: {per: 100}

  @attributes = {}

  @receivedSignal: (signal, data) ->

  @validate = []

  constructor: (data) ->
    super data

  receivedSignal: (signal, data) ->