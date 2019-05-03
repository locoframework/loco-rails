class App.Models.Room extends App.Models.Base
  @identity = "Room"
  @resources = {}

  @attributes = {}

  @receivedSignal: (signal, data) ->

  @validate = []

  constructor: (data) ->
    super data

  receivedSignal: (signal, data) ->